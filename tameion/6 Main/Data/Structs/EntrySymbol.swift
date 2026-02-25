//
//  EntrySymbol.swift
//  tameion
//
//  Created by Shola Ventures on 2/3/26.
//
import FirebaseFirestore
import FirebaseCore
import SwiftUI

struct EntrySymbol: Codable, Identifiable {
    @DocumentID var id: String?

    var userId: String
    var journalId: String
    var entryId: String
    var symbolId: String
    var source: Author
    var confidence: Float?

    var createdAt: Date
    var updatedAt: Date
    var deleted: Bool

    static var empty: EntrySymbol {
        let date = Date()
        return EntrySymbol(
            userId: "",
            journalId: "",
            entryId: "",
            symbolId: "",
            source: Author.system,
            confidence: nil,
            createdAt: date,
            updatedAt: date,
            deleted: false
        )
    }
}



// MARK: - EntrySymbol Update

enum EntrySymbolUpdate: FirestoreUpdate {
    case symbolId(String)
    case confidence(Float)

    var data: [String: Any] {
        switch self {
        case .symbolId(let val):               return ["symbolId": val]
        case .confidence(let val):             return ["confidence": val]
        }
    }
}


extension DatabaseService {

    func createEntrySymbol(_ symbol: EntrySymbol) async -> (success: Bool, error: Error?) {
        return await create(symbol, in: Collections.entrySymbols)
    }

    func readEntrySymbol(from id: String) async -> (success: Bool, data: EntrySymbol?, error: Error?) {
        return await read(EntrySymbol.self, from: Collections.entrySymbols, documentID: id)
    }

    func updateEntrySymbol(id: String, updates: [EntrySymbolUpdate]) async -> (success: Bool, error: Error?) {
        return await self.update(id, in: Collections.entrySymbols, updates: updates)
    }

    func deleteEntrySymbol(id: String) async -> (success: Bool, error: Error?) {
        return await delete(from: Collections.entrySymbols, documentID: id)
    }
}

