//
//  Tag.swift
//  tameion
//
//  Created by Shola Ventures on 1/19/26.
//
import FirebaseFirestore
import FirebaseCore

struct Tag: Codable, Identifiable {
    @DocumentID var id: String?
    
    var name: String
    var userId: String
    var journalId: String

    // TODO: DOES THIS NEED TO BE AN ARRAY
    var entryId: String

    var createdAt: Date
    var updatedAt: Date
    var deleted: Bool

    static var empty: Tag {
        Tag(
            name: "",
            userId: "",
            journalId: "",
            entryId: "",
            createdAt: Date(),
            updatedAt: Date(),
            deleted: false
        )
    }
}



// MARK: - Tag Update

enum TagUpdate: FirestoreUpdate {
    case name(String)
    case deleted(Bool)

    var data: [String: Any] {
        switch self {
        case .name(let val):                return ["type": val]
        case .deleted(let val):             return ["deleted": val]
        }
    }
}


extension DatabaseService {

    func createTag(_ tag: Tag) async -> (success: Bool, error: Error?) {
        return await create(tag, in: Collections.tags, documentID: tag.id)
    }
    
    func readTag(tagId: String) async -> (success: Bool, data: Tag?, error: Error?) {
        return await read(Tag.self, from: Collections.tags, documentID: tagId)
    }

    func readTags(userId: String) async -> (success: Bool, data: [Tag]?, error: Error?) {
        return await readCollection(Tag.self, from: Collections.tags) { query in
            query.whereField("userId", isEqualTo: userId)
                .order(by: "createdAt", descending: true)
        }
    }

    func updateTag(id: String, updates: [TagUpdate]) async -> (success: Bool, error: Error?) {
        return await self.update(id, in: Collections.tags, updates: updates)
    }

    func deleteTag(tagId: String) async -> (success: Bool, error: Error?) {
        return await delete(from: Collections.tags, documentID: tagId)
    }

}

