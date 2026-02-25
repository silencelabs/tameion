//
//  UserResearch.swift
//  tameion
//
//  Created by Shola Ventures on 1/25/26.
//
import FirebaseFirestore
import FirebaseCore


struct UserResearch: Codable, Identifiable {
    @DocumentID var id: String?

    var ageRange: String
    var appleAgeRange: String
    var journalingHabits: String
    var bibleHabits: String
    var productGoals: [String]

    var createdAt: Date
    var updatedAt: Date
    var deleted: Bool

    static var empty: UserResearch {
        UserResearch(
            ageRange: "",
            appleAgeRange: "",
            journalingHabits: "",
            bibleHabits: "",
            productGoals: [],
            createdAt: Date(),
            updatedAt: Date(),
            deleted: false
        )
    }
}



// MARK: - User Research Update

enum UserResearchUpdate: FirestoreUpdate {
    case ageRange(String)
    case appleAgeRange(String)
    case journalingHabits(String)
    case bibleHabits(String)
    case productGoals([String])
    case deleted(Bool)

    var data: [String: Any] {
        switch self {
        case .ageRange(let val):                    return ["ageRange": val]
        case .appleAgeRange(let val):               return ["appleAgeRange": val]
        case .journalingHabits(let val):            return ["journalingHabits": val]
        case .bibleHabits(let val):                 return ["bibleHabits": val]
        case .productGoals(let val):                return ["productGoals": val]
        case .deleted(let val):                     return ["deleted": val]
        }
    }
}


extension DatabaseService {

    func createUserResearch(_ userResearch: UserResearch) async -> (success: Bool, error: Error?) {
        return await create(userResearch, in: Collections.userResearch, documentID: userResearch.id)
    }

    func readUserResearch(id: String) async -> (success: Bool, data: UserResearch?, error: Error?) {
        return await read(UserResearch.self, from: Collections.userResearch, documentID: id)
    }

    func updateUserResearch(id: String, updates: [UserResearchUpdate]) async -> (success: Bool, error: Error?) {
        return await self.update(id, in: Collections.userResearch, updates: updates)
    }

    func deleteUserResearch(id: String) async -> (success: Bool, error: Error?) {
        return await delete(from: Collections.userResearch, documentID: id)
    }
}

