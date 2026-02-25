//
//  UserSettings.swift
//  tameion
//
//  Created by Shola Ventures on 1/19/26.
//
import FirebaseFirestore
import FirebaseCore


struct UserSettings: Codable, Identifiable {
    @DocumentID var id: String?

    var preferredBibleVersion: String
    var biometricsEnabled: Bool
    var notificationsEnabled: Bool
    var dailyReminderEnabled: Bool
    var dailyReminderTime: String
    var registeredDeviceID: String

    var createdAt: Date
    var updatedAt: Date
    var deleted: Bool

    static var empty: UserSettings {
        UserSettings(
            preferredBibleVersion: "",
            biometricsEnabled: false,
            notificationsEnabled: false,
            dailyReminderEnabled: false,
            dailyReminderTime: "",
            registeredDeviceID: "",
            createdAt: Date(),
            updatedAt: Date(),
            deleted: false
        )
    }
}



// MARK: - UserSettings Update

enum UserSettingsUpdate: FirestoreUpdate {
    case biometrics(Bool)
    case notifications(Bool)
    case reminder(Bool)
    case reminderTime(String)
    case device(String)
    case deleted(Bool)

    var data: [String: Any] {
        switch self {
        case .biometrics(let val):                      return ["biometricsEnabled": val]
        case .notifications(let val):                   return ["notificationsEnabled": val]
        case .reminder(let val):                        return ["dailyReminderEnabled": val]
        case .reminderTime(let val):                    return ["dailyReminderTime": val]
        case .device(let val):                          return ["registeredDeviceID": val]
        case .deleted(let val):                         return ["deleted": val]
        }
    }
}


extension DatabaseService {

    func createUserSettings(_ userSettings: UserSettings) async -> (success: Bool, error: Error?) {
        return await create(userSettings, in: Collections.userSettings, documentID: userSettings.id)
    }

    func readUserSettings(userSettingsId: String) async -> (success: Bool, data: UserSettings?, error: Error?) {
        return await read(UserSettings.self, from: Collections.userSettings, documentID: userSettingsId)
    }

    func updateUserSettings(id: String, updates: [UserSettingsUpdate]) async -> (success: Bool, error: Error?) {
        return await self.update(id, in: Collections.userSettings, updates: updates)
    }
    
    func deleteUserSettings(userSettingsId: String) async -> (success: Bool, error: Error?) {
        return await delete(from: Collections.userSettings, documentID: userSettingsId)
    }
}

