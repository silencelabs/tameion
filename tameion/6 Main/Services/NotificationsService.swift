//
//  NotificationsService.swift
//  tameion
//
//  Created by Shola Ventures on 1/14/26.
//
import OneSignalFramework

final class NotificationsService: NSObject, ObservableObject  {

    static let shared = NotificationsService()

    private let apiKey: String
    private let appId: String
    private let session: URLSession
    private let endpoint = URL(string: "https://onesignal.com/api/v1/notifications")!

    private override init() {
        // Empty init - configuration happens separately

        // For  Cron-Style Scheduling
        guard let apiKey = Bundle.main.object(
            forInfoDictionaryKey: "OneSignalAPIKey"
        ) as? String else {
            fatalError("Missing ResendAPIKey")
        }

        guard let appId = Bundle.main.object(
            forInfoDictionaryKey: "OneSignalAppID"
        ) as? String else {
            fatalError("Missing ResendAPIKey")
        }

        self.apiKey = apiKey
        self.appId = appId
        self.session = URLSession(configuration: .default)
    }
    
    func requestPermission() {

        // Use this method to prompt for push notifications.
        // We recommend removing this method after testing and instead use In-App Messages to prompt for notification permission.
        OneSignal.Notifications.requestPermission({ accepted in
          print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: false)
    }

    func playerId() -> String? {
        return OneSignal.User.pushSubscription.id

    }

    func isPushNotificationsEnabled() -> Bool {
        OneSignal.User.pushSubscription.optedIn
    }

    func optIn() {
        OneSignal.User.pushSubscription.optIn()
    }

    // MARK: - Core Sender (REST)

    func schedule(
        reminderTime: String,
    ) async {

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "app_id": self.appId,
            "include_player_ids": [self.playerId()],
            "contents": [
                "en": "📝 Take a moment to journal today"
            ],
            "send_after": reminderTime,
            "recurrence": [
                "frequency": "daily"
            ]
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (_, response) = try await session.data(for: request)

            if let http = response as? HTTPURLResponse,
               !(200...299).contains(http.statusCode) {
                #if DEBUG
                print("📧 Resend failed with status:", http.statusCode)
                #endif
            }
        } catch {
            #if DEBUG
            print("📧 Resend network error:", error)
            #endif
        }
    }

}
