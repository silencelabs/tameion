//
//  User.swift
//  tameion
//
//  Created by Shola Ventures on 1/19/26.
//
import FirebaseFirestore
import FirebaseCore

struct TUser: Codable, Identifiable {
    @DocumentID var id: String?
    
    var lastName: String
    var firstName: String
    var displayName: String
    var email: String

    var createdAt: Date
    var updatedAt: Date
    var deleted: Bool

    static var empty: TUser {
        TUser(
            lastName: "",
            firstName: "",
            displayName: "",
            email: "",
            createdAt: Date(),
            updatedAt: Date(),
            deleted: false
        )
    }
}

// MARK: - User Update

enum UserUpdate: FirestoreUpdate {
    case email(String)
    case name(String)
    case lastName(String)
    case firstName(String)
    case deleted(Bool)

    var data: [String: Any] {
        switch self {
        case .email(let val):                   return ["email": val]
        case .name(let val):                    return ["displayName": val]
        case .lastName(let val):                return ["lastName": val]
        case .firstName(let val):               return ["firstName": val]
        case .deleted(let val):                 return ["deleted": val]
        }
    }
}


extension DatabaseService {

    func createUser(_ user: TUser) async -> (success: Bool, error: Error?) {
        return await create(user, in: Collections.users)
    }
    
    func readUser(id: String) async -> (success: Bool, data: TUser?, error: Error?)  {
        return await read(TUser.self, from: Collections.users, documentID: id)
    }

    func updateUser(id: String, updates: [UserUpdate]) async -> (success: Bool, error: Error?) {
        return await self.update(id, in: Collections.users, updates: updates)
    }

    func deleteUser(id: String) async -> (success: Bool, error: Error?)  {
        return await delete(from: Collections.users, documentID: id)
    }
}

