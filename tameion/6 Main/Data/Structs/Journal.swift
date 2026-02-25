//
//  Journal.swift
//  tameion
//
//  Created by Shola Ventures on 1/19/26.
//
import FirebaseFirestore
import FirebaseCore

struct Journal: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    
    var name: String
    var userId: String
    var byline: String
    var color: String

    var createdAt: Date
    var updatedAt: Date
    var deleted: Bool?

    static func == (lhs: Journal, rhs: Journal) -> Bool {
        lhs.id == rhs.id
    }

    static let AllJournal = Journal(
        id: "",
        name: DSCopy.Journal.allJournalLabel,
        userId: "",
        byline: "",
        color: "",
        createdAt: Date(),
        updatedAt: Date(),
        deleted: false
    )

    static var empty: Journal {
        Journal(
                name: "",
                userId: "",
                byline: "",
                color: "",
                createdAt: Date(),
                updatedAt: Date(),
                deleted: false
                )
    }
}


// MARK: - Journal Update

enum JournalUpdate: FirestoreUpdate {
    case name(String)
    case byline(String)
    case color(String)
    case deleted(Bool)

    var data: [String: Any] {
        switch self {
        case .name(let val):                return ["name": val]
        case .byline(let val):              return ["byline": val]
        case .color(let val):               return ["color": val]
        case .deleted(let val):             return ["deleted": val]
        }
    }
}

extension DatabaseService {
    
    func createJournal(_ journal: Journal) async -> (success: Bool, error: Error?) {
        return await create(journal, in: Collections.journals)
    }

    func readJournal(id: String) async -> (success: Bool, data: Journal?, error: Error?) {
        return await read(Journal.self, from: Collections.journals, documentID: id)
    }

    // TODO: SCOPE THIS DOWN TO ONLY READ FOR THIS USER
    func readUserJournals(from userId: String) async -> (success: Bool, data: [Journal]?, error: Error?) {
        return await readCollection(Journal.self, from: Collections.journals) { query in
            query.whereField("userId", isEqualTo: userId)
                .order(by: "createdAt", descending: true)
        }
    }

    func updateJournal(id: String, updates: [JournalUpdate]) async -> (success: Bool, error: Error?) {
        return await self.update(id, in: Collections.journals, updates: updates)
    }

    func softDeleteJournal(id: String) async -> (success: Bool, error: Error?) {
        let updates = [JournalUpdate.deleted(true)]
        return await self.update(id, in: Collections.journals, updates: updates)
    }

    func deleteJournal(journalId: String) async -> (success: Bool, error: Error?) {
        return await delete(from: Collections.journals, documentID: journalId)
    }
}

