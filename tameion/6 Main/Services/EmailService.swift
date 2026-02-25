//
//  EmailService.swift
//  tameion
//
//  Created by Shola Ventures on 1/13/26.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftUI


final class EmailService: ObservableObject {

    static let shared = EmailService()

    private let apiKey: String
    private let session: URLSession
    private let endpoint = URL(string: "https://api.resend.com/emails")!

    private init() {
        guard let key = Bundle.main.object(
            forInfoDictionaryKey: "ResendAPIKey"
        ) as? String else {
            fatalError("Missing ResendAPIKey")
        }

        self.apiKey = key
        self.session = URLSession(configuration: .default)
    }

    // MARK: - Public API (one-liners)

    func sendWelcome() {
        Task.detached(priority: .background) {
            guard let user = await self.currentUser() else { return }
            await self.send(to: user.email, templateId: DSCopy.Email.welcomeAlias, variables: [
                DSCopy.Email.Variable.firstName: (user.displayName != nil) ? user.displayName! : ""
            ])
        }
    }
    

    // MARK: - Core Sender (REST)

    private func send(
        to: String?,
        templateId: String,
        variables: [String:Any]
    ) async {
        guard let to else { return }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "to": [to],
            "template": [
                    "id": templateId,
                    "variables": variables
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

    // MARK: - MainActor bridges (Swift 6 safe)

    private func currentUser() async -> User? {
        await MainActor.run {
            FirebaseAuthService.shared.currentUser
        }
    }
    
    private func fromTameion() -> String {
        return "Tameion <hello@tameion.app>"
    }

    private func fromNoReplyAddress() async -> String {
        await MainActor.run {
            let auth = FirebaseAuthService.shared

            if auth.isAuthenticated, let email = auth.email {
                let name = auth.displayName ?? "App User"
                return "\(name) <\(email)>"
            }

            return "Tameion <noreply@tameion.app>"
        }
    }
}
