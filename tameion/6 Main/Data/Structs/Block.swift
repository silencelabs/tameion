//
//  Block.swift
//  tameion
//
//  Created by Shola Ventures on 1/25/26.
//
//
import FirebaseFirestore
import FirebaseCore


struct Block: Codable, Identifiable {
    @DocumentID var id: String?

    var userId: String
    var journalId: String
    var entryId: String
    var type: String
    var order: Int
    var content: BlockContent

    var createdAt: Date
    var updatedAt: Date
    var deleted: Bool

    static var empty: Block {
        Block(
            userId: "",
            journalId: "",
            entryId: "",
            type: "",
            order: 0,
            content: BlockContent.text(""),
            createdAt: Date(),
            updatedAt: Date(),
            deleted: false,
        )
    }
}


// MARK: - Block Content Types

enum BlockContent: Codable {
  case text(String)
  case image(assetId: String, caption: String?)
  case audio(assetId: String, duration: Double)
  case scripture(reference: String, translation: String, text: String)
}



// MARK: - Block Update

enum BlockUpdate: FirestoreUpdate {
    case type(String)
    case order(Int)
    case content(BlockContent)
    case deleted(Bool)

    var data: [String: Any] {
        switch self {
        case .type(let val):                return ["type": val]
        case .order(let val):               return ["order": val]
        case .content(let val):             return ["content": val] // TODO: POSSIBLY ENCODE, NEED TO TEST
        case .deleted(let val):             return ["deleted": val]
        }
    }
}

extension DatabaseService {

    func createBlock(_ block: Block) async -> (success: Bool, error: Error?) {
        return await create(block, in: Collections.blocks)
    }

    func readBlock(id: String) async -> (success: Bool, data: Block?, error: Error?) {
        return await read(Block.self, from: Collections.blocks, documentID: id)
    }

    // TODO: SCOPE THIS DOWN TO ONLY READ FOR THIS ENTRY
    func readBlocks(from entryId: String) async -> (success: Bool, data: [Block]?, error: Error?) {
        return await readCollection(Block.self, from: Collections.blocks) { query in
            query.whereField("entryId", isEqualTo: entryId)
                .order(by: "order", descending: false)
        }
    }

    func updateBlock(id: String, updates: [BlockUpdate]) async -> (success: Bool, error: Error?) {
        return await self.update(id, in: Collections.blocks, updates: updates)
    }

    func softDeleteBlock(id: String) async -> (success: Bool, error: Error?) {
        let updates = [BlockUpdate.deleted(true)]
        return await self.update(id, in: Collections.blocks, updates: updates)
    }

    func deleteBlock(id: String) async -> (success: Bool, error: Error?) {
        return await delete(from: Collections.blocks, documentID: id)
    }

}

