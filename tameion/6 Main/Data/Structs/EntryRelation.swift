//
//  EntryRelation.swift
//  tameion
//
//  Created by Shola Ventures on 2/2/26.
//
import FirebaseFirestore
import FirebaseCore
import SwiftUI

struct EntryRelation: Codable, Identifiable {
    @DocumentID var id: String?

    var userId: String
    var journalId: String

    var fromEntryId: String
    var toEntryId: String
    var relationType: EntryRelationType

    var createdAt: Date
    var updatedAt: Date
    var deleted: Bool

    static var empty: EntryRelation {
        let date = Date()
        return EntryRelation(
            userId: "",
            journalId: "",
            fromEntryId: "",
            toEntryId: "",
            relationType: EntryRelationType.explains,
            createdAt: date,
            updatedAt: date,
            deleted: false
        )
    }
}



// MARK: - Entry Relation Update

enum EntryRelationUpdate: FirestoreUpdate {
    case from(String)
    case to(String)
    case type(EntryRelationType)
    case deleted(Bool)

    var data: [String: Any] {
        switch self {
        case .from(let val):                return ["fromEntryId": val]
        case .to(let val):                  return ["toEntryId": val]
        case .type(let val):                return ["relationType": val.rawValue]
        case .deleted(let val):             return ["deleted": val]
        }
    }
}


extension DatabaseService {

    func createEntryRelationship(_ relationship: EntryRelation) async -> (success: Bool, error: Error?) {
        return await create(relationship, in: Collections.entryRelationhips)
    }

    func readEntryRelationship(id: String) async -> (success: Bool, data: EntryRelation?, error: Error?) {
        return await read(EntryRelation.self, from: Collections.entryRelationhips, documentID: id)
    }

    func readEntryRelationships(userId: String) async -> (success: Bool, data: [EntryRelation]?, error: Error?) {
        return await readCollection(EntryRelation.self, from: Collections.entryRelationhips) { query in
            query.whereField("userId", isEqualTo: userId)
                .order(by: "createdAt", descending: true)
        }
    }

    func readEntryRelationships(journalId: String) async -> (success: Bool, data: [EntryRelation]?, error: Error?) {
        return await readCollection(EntryRelation.self, from: Collections.entryRelationhips) { query in
            query.whereField("journalId", isEqualTo: journalId)
                .order(by: "createdAt", descending: true)
        }
    }

    func updateRelationship(id: String, update: [EntryRelationUpdate]) async -> (success: Bool, error: Error?) {
        return await self.update(id, in: Collections.entryRelationhips, updates: update)
    }

    func deleteRelationship(id: String) async -> (success: Bool, error: Error?) {
        return await delete(from: Collections.entryRelationhips, documentID: id)
    }
}


