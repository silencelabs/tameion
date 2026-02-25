//
//  PersonalSymbol.swift
//  tameion
//
//  Created by Shola Ventures on 2/3/26.
//
import FirebaseFirestore
import FirebaseCore
import SwiftUI

struct PersonalSymbol: Codable, Identifiable {
    @DocumentID var id: String?

    var userId: String
    var symbolId: String
    var personalMeaning: String

    var createdAt: Date
    var updatedAt: Date
    var deleted: Bool

    static var empty: PersonalSymbol {
        let date = Date()
        return PersonalSymbol(
            userId: "",
            symbolId: "",
            personalMeaning: "",
            createdAt: date,
            updatedAt: date,
            deleted: false
        )
    }
}



// MARK: - Personal Symbol Update

enum PersonalSymbolUpdate: FirestoreUpdate {
    case symbolId(String)
    case meaning(String)
    case deleted(Bool)

    var data: [String: Any] {
        switch self {
        case .symbolId(let val):                return ["symbolId": val]
        case .meaning(let val):                 return ["personalMeaning": val]
        case .deleted(let val):                 return ["deleted": val]
        }
    }
}


extension DatabaseService {

    func createPersonalSymbol(_ symbol: PersonalSymbol) async -> (success: Bool, error: Error?) {
        return await create(symbol, in: Collections.personalSymbols)
    }

    func readPersonalSymbol(id: String) async -> (success: Bool, data: PersonalSymbol?, error: Error?) {
        return await read(PersonalSymbol.self, from: Collections.personalSymbols, documentID: id)
    }

    func updatePersonalSymbol(id: String, updates: [PersonalSymbolUpdate]) async -> (success: Bool, error: Error?) {
        return await self.update(id, in: Collections.personalSymbols, updates: updates)
    }

    func deletePersonalSymbol(id: String) async -> (success: Bool, error: Error?) {
        return await delete(from: Collections.personalSymbols, documentID: id)
    }
}



