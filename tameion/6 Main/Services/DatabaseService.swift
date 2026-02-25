//
//  DatabaseService.swift
//  tameion
//
//  Created by Shola Ventures on 1/19/26.
//
import Foundation
import SwiftUI
import Combine
import Sentry

import FirebaseCore
import FirebaseFirestore
import FirebaseCrashlytics


@MainActor
final class DatabaseService: ObservableObject {

    static let shared = DatabaseService()

    let db = Firestore.firestore()
    let pageSize = 50

    enum Collections {
        static let users         = "users"
        static let journals      = "journals"
        static let entries       = "entries"
        static let blocks        = "blocks"
        static let entryRelationhips = "relationships"
        static let scripture     = "scriptures"
        static let symbols       = "symbols"
        static let entrySymbols  = "entry_symbols"
        static let personalSymbols = "personal_symbols"
        static let tags          = "tags"
        static let userSettings  = "user_settings"
        static let userResearch  = "user_research"
    }


    // MARK: - Active State

    @Published var currentUserId: String? = nil

    @Published var activeJournal: Journal? = nil  // nil == "All"
    @Published var activeUser: TUser?
    @Published var activeSettings: UserSettings?
    @Published var activeResearch: UserResearch?

    @Published private(set) var activeJournals: [Journal] = []

    // MARK: REBUILDING
    @Published private(set) var entryStore: [String: Entry] = [:]
    @Published private(set) var seekEntryIds: [String] = []
    @Published private(set) var reflectEntryIds: [String:[String]] = [:]

    // MARK: Seek — one listener for all actionable entries, UI handles section filtering
    @Published private(set) var actionEntries: [Entry] = []
    @Published private(set) var activeSeekSections: [EntryActionSection] = []

    // MARK: Reflect — paginated per journal key ("all" or journalId)
    @Published private(set) var entriesByJournal: [String: [Entry]] = [:]
    @Published private(set) var activeReflectSections: [EntrySection] = []

    // Per-journal pagination state
    // Missing key == no cursor yet (first page not loaded). Never store Optional inside.
    private var cursorsByJournal:    [String: DocumentSnapshot] = [:]
    private var endReachedByJournal: [String: Bool]             = [:]
    private var loadingByJournal:    [String: Bool]             = [:]

    /// True while a `fetchNextPage` call is in-flight. Observe this to show a spinner.
    @Published private(set) var isFetchingMore = false

    // Seek listener
    private var seekListener: ListenerRegistration?
    private var reflectListener: ListenerRegistration?

    // Async task listeners
    private var cancellables   = Set<AnyCancellable>()
    private var userTask:       Task<Void, Never>?
    private var journalsTask:   Task<Void, Never>?
    private var settingsTask:   Task<Void, Never>?
    private var researchTask:   Task<Void, Never>?


    // MARK: - Init

    init() {
        // Auth change → restart all listeners
        $currentUserId
            .removeDuplicates()
            .sink { [weak self] uid in
                guard let self else { return }
                self.stopAllListeners()

                if let userId = uid {
                    self.setActiveUserData(userId: userId)
                    self.startJournalListener(userId: userId)
                    self.startSeekListener(userId: userId)
                    self.startReflectListener(userId: userId)
                } else {
                    self.activeUser       = nil
                    self.activeSettings   = nil
                    self.actionEntries    = []
                    self.activeJournals   = []
                    self.entriesByJournal = [:]
                }
            }
            .store(in: &cancellables)

        Publishers.CombineLatest($reflectEntryIds, $activeJournal)
            .map { [weak self] (dict, journal) -> [EntrySection] in
                guard let self = self else { return [] }

                // 1. Get the correct key (e.g., "work" or "all")
                let key = Self.journalKey(journal)
                let ids = dict[key] ?? []

                // 2. Hydrate from Store
                let entries = ids.compactMap { self.entryStore[$0] }

                // 3. Group by Date
                return self.groupByDate(entries)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$activeReflectSections)

        $seekEntryIds
            .removeDuplicates()
            .map { [weak self] ids -> [EntryActionSection] in
                guard let self = self else { return [] }

                // 1. Hydrate: Turn IDs into Objects from the Master Store
                let entries = ids.compactMap { self.entryStore[$0] }

                // 2. Process: Group the hydrated objects
                return self.groupByType(entries)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$activeSeekSections)
    }

    /// Canonical key for the entriesByJournal / cursor / end-reached dictionaries.
    private static func journalKey(_ journal: Journal?) -> String {
        guard let id = journal?.id, !id.isEmpty else { return "all" }
        return id
    }
    private static func journalKey(_ id: String?) -> String {
        return id.flatMap { $0.isEmpty ? nil : $0 } ?? "all"
    }

    func startReflectListener(userId: String) {
        let key = Self.journalKey(activeJournal)

        // Reset this journal's state
        reflectListener?.remove()

        // Reset this journal's state
        entriesByJournal[key]    = []
        cursorsByJournal.removeValue(forKey: key)
        endReachedByJournal[key] = false
        loadingByJournal[key]    = false

        var query: Query = db.collection(Collections.entries)
            .whereField("userId", isEqualTo: userId)
            .whereField("deleted", isEqualTo: false)
            .order(by: "createdAt", descending: true)
            .limit(to: pageSize)

        if let jId = activeJournal?.id, !jId.isEmpty {
            query = query.whereField("journalId", isEqualTo: jId)
        }

        reflectListener = query.addSnapshotListener { [weak self] snapshot, error in
            guard let self else { return }
            if let error = error {
                SentrySDK.capture(error: error) { scope in
                    scope.setTag(value: key, key: "journal_key")
                    scope.setContext(value: ["key": key], key: "pagination_details")
                }
                return
            }
            guard let docs = snapshot?.documents else {
                return
            }

            let items = docs.compactMap { try? $0.data(as: Entry.self) }
            for entry in items {
                if let id = entry.id {
                    self.entryStore[id] = entry
                }
            }
            self.reflectEntryIds[key] = items.compactMap { $0.id }

            // Advance cursor to the last doc so loadMore knows where to start
            if let last = docs.last {
                self.cursorsByJournal[key] = last
            }
            if docs.count < self.pageSize {
                self.endReachedByJournal[key] = true
            }

        }
        isFetchingMore = false
    }


    // MARK: - Listener Lifecycle

    private func stopAllListeners() {
        seekListener?.remove()
        seekListener = nil

        journalsTask?.cancel();
        journalsTask = nil

        cursorsByJournal.removeAll()
        endReachedByJournal.removeAll()
        loadingByJournal.removeAll()
        isFetchingMore = false

        UserDefaults.standard.removeObject(forKey: settingsCacheKey)
    }

    func setActiveUserData(userId: String) {

        Task { @MainActor in
            let user = await readUser(id: userId)
            self.activeUser = user.data
        }
    }

    func createActiveUserDetails(userId: String) {
        Task { @MainActor in
            var (s, r) = (UserSettings.empty, UserResearch.empty)
            s.id = userId
            r.id = userId

            _ = await createUserSettings(s)
            _ = await createUserResearch(r)

            self.activeSettings = s
            self.activeResearch = r
        }
    }

    func startJournalListener(userId: String) {
        journalsTask?.cancel()
        journalsTask = Task { @MainActor in
            for await journals in listenCollection(Journal.self, from: Collections.journals, where: {
                $0.whereField("userId", isEqualTo: userId)
            }) {
                var updated = journals
                updated.insert(.AllJournal, at: 0)
                self.activeJournals = updated
                if self.activeJournal == nil {
                    self.activeJournal = .AllJournal
                }
            }
        }
    }




    // MARK: - Seek Listener

    /// One real-time listener for ALL actionable entries belonging to this user.
    /// Filters actionRequired == true and deleted == false in Firestore.
    /// Note: requires a composite index on (userId, actionRequired, deleted, createdAt).
    func startSeekListener(userId: String) {
        seekListener?.remove()

        seekListener = db.collection(Collections.entries)
            .whereField("userId", isEqualTo: userId)
            .whereField("actionRequired", isEqualTo: true)
            .whereField("deleted", isEqualTo: false)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }
                if let error = error {
                    SentrySDK.capture(error: error)
                    return
                }
                let entries = snapshot?.documents.compactMap { try? $0.data(as: Entry.self) } ?? []
                for entry in entries {
                    if let id = entry.id {
                        self.entryStore[id] = entry
                    }
                }
                self.seekEntryIds = entries.compactMap { $0.id }
            }
    }


    // MARK: - Reflect Pagination

    /// Builds and executes a one-time fetch for the next page of a given journal lane.
    /// Called by `loadMoreEntries()` and can be called directly if you know the journalId.
    /// Pages 2+ intentionally use `getDocuments()` rather than a new listener —
    /// older pages don't need live updates and adding more listeners would waste reads.
    func fetchNextPage(userId: String, journalId: String?) {
        let key = Self.journalKey(journalId)

        guard !endReachedByJournal[key, default: false] else {
            return
        }

        // Ensure we have a cursor from the listener/previous fetch
        guard let cursor = cursorsByJournal[key] else {
            return
        }

        // --- 2. THE LOCK ---
        // Set this IMMEDIATELY to block any other calls from the UI
        loadingByJournal[key] = true
        isFetchingMore = true

        // --- 3. THE QUERY CONSTRUCTION ---
        var query = db.collection(Collections.entries)
            .whereField("userId", isEqualTo: userId)
            .whereField("deleted", isEqualTo: false)

        if key != "all" {
            query = query.whereField("journalId", isEqualTo: key)
        }

        // Order and Start After Cursor
        query = query.order(by: "createdAt", descending: true)
                     .start(afterDocument: cursor)
                     .limit(to: pageSize)

        // --- 4. EXECUTION ---
        Task { @MainActor in
            // Defer ensures we UNLOCK even if the code throws an error
            defer {
                self.loadingByJournal[key] = false
                self.isFetchingMore = false
            }

            do {
                let snapshot = try await query.getDocuments()
                let docs = snapshot.documents

                if docs.isEmpty {
                    self.endReachedByJournal[key] = true
                    return
                }

                // Map data to objects
                let newItems = docs.compactMap { try? $0.data(as: Entry.self) }

                // Update Master Store (The "Data")
                for entry in newItems {
                    if let id = entry.id {
                        self.entryStore[id] = entry
                    }
                }

                // Update ID List (The "Order")
                let newIds = newItems.compactMap { $0.id }
                var currentIds = self.reflectEntryIds[key] ?? []

                // Deduplicate IDs just in case
                let filteredNewIds = newIds.filter { !currentIds.contains($0) }
                currentIds.append(contentsOf: filteredNewIds)

                self.reflectEntryIds[key] = currentIds

                // Update Cursor for next time
                if let lastDoc = docs.last {
                    self.cursorsByJournal[key] = lastDoc
                }

                // Check if this was the last page
                if docs.count < self.pageSize {
                    self.endReachedByJournal[key] = true
                }

            } catch {
                SentrySDK.capture(error: error)
            }
        }
    }


    /// Call when the user scrolls to the bottom of the Reflect list.
    /// Guards against duplicate in-flight fetches and delegates to `fetchNextPage`.
    func loadMoreEntries() {
        let key = Self.journalKey(activeJournal)
        guard !isFetchingMore || !loadingByJournal[key]! else { return }

        guard !(endReachedByJournal[key] ?? false) else { return }
        guard let cursor = cursorsByJournal[key] else { return }
        guard let userId = currentUserId else { return }

        isFetchingMore = true
        loadingByJournal[key] = true
        fetchNextPage(userId: userId, journalId: activeJournal?.id)
    }

    /// True while a page fetch is in-flight — use to show a bottom spinner.
    var isReflectLoading: Bool { isFetchingMore }

    /// True once all pages for the active journal have been loaded.
    var hasReflectReachedEnd: Bool {
        endReachedByJournal[Self.journalKey(activeJournal)] ?? false
    }


    // MARK: - Grouping Helpers

    private func groupByDate(_ entries: [Entry]) -> [EntrySection] {
        let grouped = Dictionary(grouping: entries) {
            Calendar.current.startOfDay(for: $0.createdAt)
        }
        return grouped
            .map { EntrySection(date: $0, entries: $1.sorted { $0.createdAt > $1.createdAt }) }
            .sorted { $0.date > $1.date }
    }

    private func groupByType(_ entries: [Entry]) -> [EntryActionSection] {
        let live = entries.filter { !($0.deleted ?? false) }

        return [
            EntryActionSection(
                title:   DSCopy.Timeline.SeekSections.title1,
                helper:  DSCopy.Timeline.SeekSections.helper1,
                color:   DSColor.raspberry_red,
                entries: live.filter { $0.urgency == .urgent && $0.obedienceStatus != .completed }
            ),
            EntryActionSection(
                title:   DSCopy.Timeline.SeekSections.title2,
                helper:  DSCopy.Timeline.SeekSections.helper2,
                color:   DSColor.terracotta,
                entries: live.filter {
                    $0.obedienceStatus != .completed &&
                    $0.urgency != .urgent &&
                    $0.obedienceStatus != .in_progress &&
                    $0.obedienceStatus != .waiting
                }
            ),
            EntryActionSection(
                title:   DSCopy.Timeline.SeekSections.title3,
                helper:  DSCopy.Timeline.SeekSections.helper3,
                color:   DSColor.mid_blue,
                entries: live.filter { $0.obedienceStatus == .in_progress && $0.urgency != .urgent }
            ),
            EntryActionSection(
                title:   DSCopy.Timeline.SeekSections.title4,
                helper:  DSCopy.Timeline.SeekSections.helper4,
                color:   DSColor.gray,
                entries: live.filter { $0.obedienceStatus == .waiting && $0.urgency != .urgent }
            )
        ].filter { !$0.entries.isEmpty }
    }


    // MARK: - Active Journal

    var currentJournalId: String? { activeJournal?.id }

    var hasActiveJournal: Bool {
        guard let id = activeJournal?.id else { return false }
        return !id.isEmpty
    }

    func setActiveJournal(_ journal: Journal?, userId: String?) {
        if let journal, let id = journal.id, !id.isEmpty {
            self.activeJournal = journal
            UserDefaults.standard.set(id, forKey: "last_journal_id_\(userId ?? "")")
        } else {
            self.activeJournal = .AllJournal
            UserDefaults.standard.removeObject(forKey: "last_journal_id_\(userId ?? "")")
        }
    }

    func setActiveUser(userId: String? = nil) async {
        guard let userId else {
            Crashlytics.crashlytics().log(
                DSCopy.Error.NotExpected.noUserId +
                DSCopy.Error.when +
                DSCopy.Error.Location.DataService.setActiveUser
            )
            return
        }
        let result = await readUser(id: userId)
        if result.success, let user = result.data {
            activeUser = user
        } else {
            let error = result.error ?? NSError(
                domain: "DatabaseService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: DSCopy.Error.genericTitle]
            )
            Crashlytics.crashlytics().record(error: error)
        }
    }


    // MARK: - Settings Cache

    private let settingsCacheKey = "cached_user_settings"

    private func saveSettingsToCache(_ settings: UserSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsCacheKey)
        }
    }

    private func loadSettingsFromCache() -> UserSettings? {
        guard let data = UserDefaults.standard.data(forKey: settingsCacheKey),
              let settings = try? JSONDecoder().decode(UserSettings.self, from: data)
        else { return nil }
        return settings
    }


    // MARK: - Swipe / Local Mutation

    private func updateEntry(_ entry: Entry, mutation: (inout Entry) -> Void) {
        for sectionIndex in activeSeekSections.indices {
            if let i = activeSeekSections[sectionIndex].entries.firstIndex(where: { $0.id == entry.id }) {
                mutation(&activeSeekSections[sectionIndex].entries[i])
            }
        }
    }


    // MARK: - CREATE

    func create<T: Codable>(
        _ model: T,
        in collection: String,
        documentID: String? = nil
    ) async -> (success: Bool, error: Error?) {
        do {
            var data = try Firestore.Encoder().encode(model)
            if data["createdAt"] == nil { data["createdAt"] = Date() }
            if data["updatedAt"] == nil { data["updatedAt"] = Date() }

            if let documentID {
                try await db.collection(collection).document(documentID).setData(data)
            } else {
                try await db.collection(collection).addDocument(data: data)
            }
            return (true, nil)
        } catch {
            return (false, error)
        }
    }


    // MARK: - LISTEN

    func listenCollection<T: Decodable>(
        _ type: T.Type,
        from collection: String,
        where predicate: ((Query) -> Query)? = nil
    ) -> AsyncStream<[T]> {
        AsyncStream { continuation in
            var query: Query = db.collection(collection)
            if let predicate { query = predicate(query) }

            let listener = query.addSnapshotListener { snapshot, error in
                if let error = error {
                    SentrySDK.capture(error: error) { scope in
                        scope.setTag(value: collection, key: "collection")
                    }
                    continuation.yield([])
                    return
                }
                continuation.yield(snapshot?.documents.compactMap { try? $0.data(as: T.self) } ?? [])
            }
            continuation.onTermination = { _ in listener.remove() }
        }
    }


    // MARK: - READ

    func read<T: Decodable>(
        _ type: T.Type,
        from collection: String,
        documentID: String
    ) async -> (success: Bool, data: T?, error: Error?) {
        do {
            let snapshot = try await db.collection(collection).document(documentID).getDocument()
            guard snapshot.exists else { return (false, nil, DatabaseError.documentNotFound) }
            return (true, try snapshot.data(as: T.self), nil)
        } catch {
            return (false, nil, error)
        }
    }

    func readCollection<T: Decodable>(
        _ type: T.Type,
        from collection: String,
        where predicate: ((Query) -> Query)? = nil
    ) async -> (success: Bool, data: [T], error: Error?) {
        do {
            var query: Query = db.collection(collection)
            if let predicate { query = predicate(query) }
            let data = try await query.getDocuments().documents.map { try $0.data(as: T.self) }
            return (true, data, nil)
        } catch {
            return (false, [], error)
        }
    }


    // MARK: - UPDATE

    func update<T: FirestoreUpdate>(
        _ id: String,
        in collection: String,
        updates: [T]
    ) async -> (success: Bool, error: Error?) {
        var mergedData: [String: Any] = ["updatedAt": Timestamp(date: Date())]
        for u in updates { mergedData.merge(u.data) { _, new in new } }

        do {
            try await db.collection(collection).document(id).updateData(mergedData)
            return (true, nil)
        } catch {
            return (false, error)
        }
    }


    // MARK: - DELETE

    func delete(from collection: String, documentID: String) async -> (success: Bool, error: Error?) {
        do {
            try await db.collection(collection).document(documentID).delete()
            return (true, nil)
        } catch {
            return (false, error)
        }
    }


    // MARK: - Error

    enum DatabaseError: LocalizedError {
        case createFailed(Error), readFailed(Error), decodeFailed(Error)
        case updateFailed(Error), deleteFailed(Error), documentNotFound

        var errorDescription: String? {
            switch self {
            case .createFailed(let e):  return "Failed to create: \(e.localizedDescription)"
            case .readFailed(let e):    return "Failed to read: \(e.localizedDescription)"
            case .decodeFailed(let e):  return "Failed to decode: \(e.localizedDescription)"
            case .updateFailed(let e):  return "Failed to update: \(e.localizedDescription)"
            case .deleteFailed(let e):  return "Failed to delete: \(e.localizedDescription)"
            case .documentNotFound:     return "Document not found"
            }
        }
    }
}


// MARK: - FirestoreUpdate Protocol

protocol FirestoreUpdate {
    var data: [String: Any] { get }
}

extension Dictionary: FirestoreUpdate where Key == String, Value == Any {
    var data: [String: Any] { self }
}


extension DatabaseService {

    /// Iterates every document in every collection and:
    /// - Removes `syncStatus`, `isArchived`, `isDeleted`
    /// - Maps `isDeleted: true` → `deleted: true`
    /// - Adds `deleted: false` if the `deleted` field is missing
    /// - Removes `title` from Journal documents specifically
    ///
    /// Safe to run multiple times — all operations are idempotent.
    func runDataMigration() async -> (success: Bool, updated: Int, error: Error?) {

        let allCollections: [(name: String, isJournals: Bool)] = [
            (Collections.users,           false),
            (Collections.journals,        true),   // extra: remove `title`
            (Collections.entries,         false),
            (Collections.blocks,          false),
            (Collections.entryRelationhips, false),
            (Collections.scripture,       false),
            (Collections.symbols,         false),
            (Collections.entrySymbols,    false),
            (Collections.personalSymbols, false),
            (Collections.tags,            false),
            (Collections.userSettings,    false),
            (Collections.userResearch,    false),
        ]

        var totalUpdated = 0

        do {
            for (collectionName, isJournals) in allCollections {
                let snapshot = try await db.collection(collectionName).getDocuments()

                // Firestore batch max is 500 — chunk just in case
                let chunks = snapshot.documents.chunked(into: 400)

                for chunk in chunks {
                    let batch = db.batch()
                    var batchHasChanges = false

                    for doc in chunk {
                        let data = doc.data()
                        var updates: [String: Any] = [:]
                        var removals: [String: Any] = [:]

                        // ── Fields to remove from every collection ──────────
                        if data["syncStatus"] != nil {
                            removals["syncStatus"] = FieldValue.delete()
                        }
                        if data["isArchived"] != nil {
                            removals["isArchived"] = FieldValue.delete()
                        }

                        // ── isDeleted → deleted migration ───────────────────
                        if let isDeleted = data["isDeleted"] {
                            removals["isDeleted"] = FieldValue.delete()
                            // Only set deleted: true if isDeleted was true.
                            // If deleted is already present, don't overwrite it.
                            if data["deleted"] == nil {
                                let wasDeleted = (isDeleted as? Bool) ?? false
                                updates["deleted"] = wasDeleted
                            }
                        }

                        // ── Add deleted: false if field is missing entirely ──
                        if data["deleted"] == nil && data["isDeleted"] == nil {
                            updates["deleted"] = false
                        }

                        // ── Journal-specific: remove title ──────────────────
                        if isJournals && data["title"] != nil {
                            removals["title"] = FieldValue.delete()
                        }

                        // ── Only write if there's something to change ───────
                        let merged = updates.merging(removals) { _, r in r }
                        if !merged.isEmpty {
                            batch.updateData(merged, forDocument: doc.reference)
                            batchHasChanges = true
                            totalUpdated += 1
                        }
                    }

                    if batchHasChanges {
                        try await batch.commit()
                    }
                }
            }
            return (true, totalUpdated, nil)

        } catch {
            SentrySDK.capture(error: error)
            return (false, totalUpdated, error)
        }
    }
}

// MARK: - Array chunk helper

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
