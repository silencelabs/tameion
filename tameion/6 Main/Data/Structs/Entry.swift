//
//  Entry.swift
//  tameion
//
//  Created by Shola Ventures on 1/19/26.
//
import FirebaseFirestore
import FirebaseCore
import SwiftUI
import FirebaseCrashlytics

struct Entry: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    
    var userId: String
    var journalId: String
    var author: Author
    var type: EntryType
    var title: String
    var previewText: String

    // Actionable Entry
    var actionRequired: Bool
    var dueDate: Date?
    var urgency: EntryUrgency?
    var estimatedEffort: EffortScale?
    var obedienceStatus: EntryStatus
    var completedAt: Date?

    // Reminder Timeline
    var remembranceCadence: RemembranceCadence
    var reminderCadence: ReminderCadence
    var lastRemindedAt: Date?

    // Stats & References
    var references: ReferenceStats
    var responseStats: ResponseStats

    // Core attributes
    var createdAt: Date
    var updatedAt: Date
    var deleted: Bool?


    static var empty: Entry {
        let date = Date()
        let refs = ReferenceStats(
            scriptureCount: 0,
            scripturePreview: [],
            symbolCount: 0,
            symbolPreview: []
        )
        let stats = ResponseStats(
            prayerCount: 0,
            praiseCount: 0,
            fastCount: 0,
            obedienceCount: 0,
            testimonyCount: 0,
            confirmationCount: 0,
            interpretationsCount: 0
        )
        return Entry(
            userId: "",
            journalId: "",
            author: Author.user,
            type: EntryType.note,
            title: "",
            previewText: "",

            actionRequired: false,
            dueDate: nil,
            urgency: EntryUrgency.normal,
            estimatedEffort: EffortScale.quick,
            obedienceStatus: EntryStatus.not_started,
            completedAt: nil,

            remembranceCadence: RemembranceCadence.none,
            reminderCadence: ReminderCadence.none,
            lastRemindedAt: nil,

            // Stats & References
            references: refs,
            responseStats: stats,

            createdAt: date,
            updatedAt: date,
            deleted: false
        )
    }

    static func == (lhs: Entry, rhs: Entry) -> Bool {
        lhs.id == rhs.id
    }

    var watchmanHour: String {
        return WatchmanHourCalculator.getHour(from: createdAt)
    }

    var badges: [EntryBadge] {
        var badges: [EntryBadge] = []

        // --- STATE / ATTENTION ---
        if type == .prayer && actionRequired && obedienceStatus != EntryStatus.completed {
            badges.append(.onPrayerList)
        }

        if let dueDate,
           obedienceStatus != EntryStatus.completed,
           dueDate < Date().addingTimeInterval(60 * 60 * 24 * 2) {
            badges.append(.urgent)
        }

        if type == .dream && responseStats.interpretationsCount < 1 {
            badges.append(.uninterpreted)
        }

        if (type == .fast || type == .instruction) && obedienceStatus == EntryStatus.in_progress {
            badges.append(.inProgress)
        }

        if type == .promise && obedienceStatus == EntryStatus.completed {
            badges.append(.fulfilled)
        }

        if obedienceStatus == EntryStatus.waiting {
            badges.append(.waiting)
        }

        // --- ACTIVITY / COUNTS ---

        if responseStats.prayerCount > 0 {
            badges.append(.prayed(responseStats.prayerCount))
        }

        if responseStats.praiseCount > 0 {
            badges.append(.praised(responseStats.praiseCount))
        }

        if responseStats.confirmationCount > 0 {
            badges.append(.confirmed(responseStats.confirmationCount))
        }

        // --- REFERENCES ---

        if !references.scripturePreview.isEmpty {
            badges.append(.scripture(preview: references.scripturePreview))
        }

        if !references.symbolPreview.isEmpty {
            badges.append(.symbols(preview: references.symbolPreview))
        }

        return prioritizeBadges(badges)
    }

    private func prioritizeBadges(_ badges: [EntryBadge]) -> [EntryBadge] {
        let priority: (EntryBadge) -> Int = {
            switch $0 {
            case .urgent: return 0
            case .needsAttention: return 1
            case .onPrayerList: return 1
            case .uninterpreted: return 2
            case .waiting: return 3
            case .inProgress: return 4
            case .fulfilled: return 5

            case .confirmed: return 6
            case .prayed: return 7
            case .praised: return 8

            case .scripture: return 9
            case .symbols: return 10
            }
        }

        return badges
            .sorted { priority($0) < priority($1) }
            .prefix(4) // hard cap per card
            .map { $0 }
    }
}



// MARK: - Entry Update

enum EntryUpdate : FirestoreUpdate {
    case journalId(String)
    case type(EntryType)
    case status(EntryStatus)
    case title(String)
    case preview(String)
    case actionable(Bool)
    case due(Date)
    case urgency(EntryUrgency)
    case effort(EffortScale)
    case remembrance(RemembranceCadence)
    case reminder(ReminderCadence)
    case deleted(Bool)

    var data: [String: Any] {
        switch self {
        case .journalId(let val):           return ["journalId": val]
        case .type(let val):                return ["type": val.rawValue]
        case .status(let val):              return ["obedienceStatus": val.rawValue]
        case .title(let val):               return ["actionRequired": val]
        case .preview(let val):             return ["previewText": val]
        case .actionable(let val):          return ["actionRequired": val]
        case .due(let val):                 return ["dueDate": Timestamp(date: val)]
        case .urgency(let val):             return ["urgency": val.rawValue]
        case .effort(let val):              return ["estimatedEffort": val.rawValue]
        case .remembrance(let val):         return ["remembranceCadence": val.rawValue]
        case .reminder(let val):            return ["reminderCadence": val.rawValue]
        case .deleted(let val):             return ["deleted": val]
        }
    }
}



extension DatabaseService {

    func createEntry(_ entry: Entry) async -> (success: Bool, error: Error?) {
        return await create(entry, in: Collections.entries)
    }
    
    func readEntry(id: String) async -> (success: Bool, data: Entry?, error: Error?) {
        return await read(Entry.self, from: Collections.entries, documentID: id)
    }

    func updateEntry(id: String, updates: [EntryUpdate]) async -> (success: Bool, error: Error?) {
        return await self.update(id, in: Collections.entries, updates: updates)
    }

    func softDeleteEntry(id: String) async -> (success: Bool, error: Error?) {
        let updates = [EntryUpdate.deleted(true)]
        return await self.update(id, in: Collections.entries, updates: updates)
    }

    func deleteEntry(id: String) async -> (success: Bool, error: Error?) {
        return await delete(from: Collections.entries, documentID: id)
    }

}

