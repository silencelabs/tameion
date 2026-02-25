//
//  MainAppView.swift
//  tameion
//
//  Created by Shola Ventures on 1/11/26.
//
import SwiftUI
import FirebaseCrashlytics


struct MainView: View {
    @Environment(\.router) var router

    @EnvironmentObject private var remoteService: DatabaseService
    @EnvironmentObject private var authService: FirebaseAuthService
    @EnvironmentObject private var networkMonitor: NetworkMonitor

    private var isDataReady: Bool {
        // We need these three to build the UI
        let hasUser = remoteService.activeUser != nil
//        let hasSettings = remoteService.activeSettings != nil
        let hasJournals = !remoteService.activeJournals.isEmpty

        return hasUser && hasJournals
    }

    var body: some View {
        ZStack {
            if !isDataReady {
                // This replaces your manual isInitialLoad state
                // ProgressView()
                VStack(spacing: 20) {
                    ProgressView()
                    Text("Syncing your journal...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                TabView {
                    Tab(DSCopy.Navigation.ReflectTab.name, systemImage: DSCopy.Navigation.ReflectTab.systemImage) {
                        ReflectView()
                    }

                    Tab(DSCopy.Navigation.SeekTab.name, systemImage: DSCopy.Navigation.SeekTab.systemImage) {
                        SeekView()
                    }

                    Tab("Shortcuts", systemImage: DSCopy.Navigation.SeekTab.systemImage) {
                        ShortcutsView()
                    }

                    Tab(DSCopy.Navigation.AddEntry.name, systemImage: DSCopy.Navigation.AddEntry.systemImage, role: .search) {
                        ComposeEntryView()
                    }
                }
            }

            // Network/sync status overlay (always on top)
            VStack {
                Spacer()
                if !networkMonitor.isConnected {
                    NetworkStatusBanner()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if isDataReady {
                    HStack(spacing: DSSpacing.md) {
                        Image(systemName: DSCopy.Navigation.Account.systemImage)
                            .onTapGesture {
                                router.showScreen(.push) { _ in
                                    SettingsView()
                                }
                            }
                        }
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                if isDataReady {
                    JournalPickerView()
                }
            }
        }
    }
}
