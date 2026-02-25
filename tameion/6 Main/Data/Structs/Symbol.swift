//
//  Symbol.swift
//  tameion
//
//  Created by Shola Ventures on 2/2/26.
//
//
import FirebaseFirestore
import FirebaseCore
import SwiftUI

struct Symbol: Codable, Identifiable {
    @DocumentID var id: String?

    var parentId: String
    var key: String
    var displayName: String
    var shortMeaning: String
    var meaning: String

    var createdAt: Date
    var updatedAt: Date
    var deleted: Bool

    static var empty: Symbol {
        let date = Date()
        return Symbol(
            parentId: "",
            key: "",
            displayName: "",
            shortMeaning: "",
            meaning: "",
            createdAt: date,
            updatedAt: date,
            deleted: false
        )
    }
}



// MARK: - Symbol Update

enum SymbolUpdate: FirestoreUpdate {
    case key(String)
    case name(String)
    case shortMeaning(String)
    case longMeaning(String)
    case deleted(Bool)

    var data: [String: Any] {
        switch self {
        case .key(let val):                     return ["type": val]
        case .name(let val):                    return ["order": val]
        case .shortMeaning(let val):            return ["content": val]
        case .longMeaning(let val):             return ["content": val]
        case .deleted(let val):                 return ["deleted": val]
        }
    }
}


extension DatabaseService {

    func createSymbol(_ symbol: Symbol) async -> (success: Bool, error: Error?) {
        return await create(symbol, in: Collections.symbols)
    }

    func readSymbol(id: String) async -> (success: Bool, data: Symbol?, error: Error?) {
        return await read(Symbol.self, from: Collections.symbols, documentID: id)
    }

    func updateSymbol(id: String, updates: [SymbolUpdate]) async -> (success: Bool, error: Error?) {
        return await self.update(id, in: Collections.symbols, updates: updates)
    }

    func deleteSymbol(id: String) async -> (success: Bool, error: Error?) {
        return await delete(from: Collections.symbols, documentID: id)
    }

}



