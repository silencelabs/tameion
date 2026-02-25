//
//  ContentView.swift
//  tameion
//
//  Created by Shola Ventures on 1/11/26.
//
import SwiftUI

struct ShortcutsView: View {

    @EnvironmentObject private var remoteService: DatabaseService
    @EnvironmentObject private var authService: FirebaseAuthService

    @State private var showCanny = false
    @State private var showSettings = false

    var body: some View {
        
        VStack {
            Spacer()
            Text("Shortcuts View")
            Text("You are already logged in.")
            Text("UserId: \(authService.currentUser?.email ?? "Unknown")")

            Spacer()

            Button("Run Data Migration") {
                Task {
                    await remoteService.runDataMigration()
                }
            }
            Button("Seed Data") {
                remoteService.createMockData()
            }
            Button("Provide Feedback") {
                showCanny = true
            }
            .sheet(isPresented: $showCanny) {
                CannyView()
            }
            Button("Crash") {
              fatalError("Crash was triggered")
            }
            Button("Sign Out") {
                authService.signOut()
            }

            Spacer()

        }.padding()
    }
}
