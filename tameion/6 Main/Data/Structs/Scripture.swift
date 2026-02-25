//
//  Scripture.swift
//  tameion
//
//  Created by Shola Ventures on 2/3/26.
//
import FirebaseFirestore
import FirebaseCore
import SwiftUI

struct Scripture: Codable, Identifiable {
    @DocumentID var id: String?

    var userId: String
    var reference: String
    var startBook: BiblicalBook
    var startChapter: Int
    var startVerse: Int
    var endBook: BiblicalBook
    var endChapter: Int
    var endVerse: Int
    var text: String
    var translation: String

    var createdAt: Date
    var updatedAt: Date
    var deleted: Bool

    static var empty: Scripture {
        let date = Date()
        return Scripture(
            userId: "",
            reference: "",
            startBook: BiblicalBook.none,
            startChapter: 0,
            startVerse: 0,
            endBook: BiblicalBook.none,
            endChapter: 0,
            endVerse: 0,
            text: "",
            translation: "",
            createdAt: date,
            updatedAt: date,
            deleted: false
        )
    }
}



// MARK: - Scripture Update

enum ScriptureUpdate: FirestoreUpdate {
    case reference(String)
    case startBook(BiblicalBook)
    case startChapter(Int)
    case startVerse(Int)
    case endBook(BiblicalBook)
    case endChapter(Int)
    case endVerse(Int)
    case text(String)
    case translation(String)
    case deleted(Bool)

    var data: [String: Any] {
        switch self {
        case .reference(let val):               return ["type": val]
        case .startBook(let val):               return ["order": val.rawValue]
        case .startChapter(let val):            return ["content": val]
        case .startVerse(let val):              return ["content": val]
        case .endBook(let val):                 return ["order": val.rawValue]
        case .endChapter(let val):              return ["content": val]
        case .endVerse(let val):                return ["content": val]
        case .text(let val):                    return ["order": val]
        case .translation(let val):             return ["content": val]
        case .deleted(let val):                 return ["deleted": val]
        }
    }
}


extension DatabaseService {
    func createScripture(_ symbol: Scripture) async -> (success: Bool, error: Error?) {
        return await create(symbol, in: Collections.scripture, documentID: symbol.id)
    }

    func readScripture(id: String) async -> (success: Bool, data: Scripture?, error: Error?) {
        return await read(Scripture.self, from: Collections.scripture, documentID: id)
    }

    func updateScripture(id: String, updates: [ScriptureUpdate]) async -> (success: Bool, error: Error?) {
        return await self.update(id, in: Collections.scripture, updates: updates)
    }

    func deleteScripture(id: String) async -> (success: Bool, error: Error?) {
        return await delete(from: Collections.scripture, documentID: id)
    }
}



