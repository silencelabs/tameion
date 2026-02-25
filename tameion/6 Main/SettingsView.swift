//
//  Settings.swift
//  tameion
//
//  Created by Shola Ventures on 1/15/26.
//

import SwiftUI
import RevenueCat
import RevenueCatUI
import FirebaseCrashlytics

struct SettingsView: View {

    @EnvironmentObject private var appState: AppState

    @EnvironmentObject private var remoteService: DatabaseService
    @EnvironmentObject private var authService: FirebaseAuthService
    @EnvironmentObject private var biometricService: BiometricAuthService
    @EnvironmentObject private var networkMonitor: NetworkMonitor

    @State private var reminderTime: Date = Date()

    private var settings: UserSettings {
        remoteService.activeSettings!
    }

    // Biometric state
    @State private var showEnableBiometricAlert = false
    @State private var showDisableBiometricAlert = false
    @State private var showBiometricErrorAlert = false
    @State private var biometricErrorMessage = ""

    var body: some View {
        ScrollView {
            VStack {

                // User Account Card
                UserAccountCard()


                // Premium Experience
                PremiumMembershipCard()


                // Start to Settings Section
                Text(DSCopy.Navigation.Settings.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, DSSpacing.md)
                    .textStyle(.title)


                // Biometrics Enabled (Enhanced with authentication)
                if biometricService.isAvailable {
                    VStack(alignment: .leading, spacing: 0) {
                        Toggle(isOn: Binding(
                            get: { settings.biometricsEnabled },
                            set: { newValue in
                                if newValue { showEnableBiometricAlert = true
                                } else { showDisableBiometricAlert = true }
                            }
                        )) {
                            HStack(spacing: 12) {
                                Image(systemName: biometricService.biometricIcon)
                                    .foregroundColor(.blue)
                                    .frame(width: 24)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(DSCopy.SettingsView.biometricsToggle)
                                        .font(.body)

                                    if !biometricService.isAvailable {
                                        Text("\(biometricService.biometricTypeString) not available on this device")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    } else if settings.biometricsEnabled {
                                        Text("App will lock when you leave")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text("Protect your journal with \(biometricService.biometricTypeString)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .disabled(!networkMonitor.isConnected)
                        .padding()
                    }
                    .alert("Enable \(biometricService.biometricTypeString)?", isPresented: $showEnableBiometricAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Enable") {
                            enableBiometric()
                        }
                    } message: {
                        Text("You'll need to use \(biometricService.biometricTypeString) to unlock your journal every time you open the app.")
                    }
                    .alert("Disable \(biometricService.biometricTypeString)?", isPresented: $showDisableBiometricAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Disable", role: .destructive) {
                            disableBiometric()
                        }
                    } message: {
                        Text("Your journal will no longer be protected by \(biometricService.biometricTypeString).")
                    }
                    .alert("Authentication Required", isPresented: $showBiometricErrorAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(biometricErrorMessage)
                    }
                }


                // Notifications Enabled
                Toggle(DSCopy.SettingsView.notificationsToggle, isOn: Binding(
                    get: { settings.notificationsEnabled },
                    set: { newValue in
                        Task {
                            let updates = [UserSettingsUpdate.notifications(newValue)]
                            _ = await remoteService.updateUserSettings(id: settings.id!, updates: updates)
                            if newValue { NotificationsService.shared.requestPermission() }
                        }
                    }
                ))
                .padding()
                .disabled(!networkMonitor.isConnected)


                // Daily Reminder Enabled
                Toggle(DSCopy.SettingsView.dailyRemindersToggle, isOn: Binding(
                    get: { settings.dailyReminderEnabled },
                    set: { newValue in
                        Task {
                            let updates = [UserSettingsUpdate.reminder(newValue)]
                            _ = await remoteService.updateUserSettings(id: settings.id!, updates: updates)
                        }
                    }
                ))
                .padding()
                .disabled(!networkMonitor.isConnected)


                // Daily Reminder Date Picker
                DatePicker(DSCopy.SettingsView.reminderTime, selection: $reminderTime, displayedComponents: [.hourAndMinute])
                    .onAppear {
                        // Initialize local date from the service string
                        reminderTime = DSFormatter.timeStringToDate(settings.dailyReminderTime) ?? Date()
                    }
                    .onChange(of: reminderTime) { _, newDate in
                        let timeString = DSFormatter.dateToTimeString(newDate)
                        Task {
                            let updates = [UserSettingsUpdate.reminderTime(timeString)]
                            _ = await remoteService.updateUserSettings(id: settings.id!, updates: updates)
                        }
                    }
                    .padding()
                    .disabled(!networkMonitor.isConnected || !settings.dailyReminderEnabled)


                FooterView()

                // Sign Out
                DSButton(DSCopy.Auth.signout, role: .danger) {
                    authService.signOut()
                }

            }.padding(DSSpacing.lg)
        }
    }

    // MARK: - Biometric Methods

    private func enableBiometric() {
        guard (authService.currentUser?.uid) != nil else {
            biometricErrorMessage = "No authenticated user"
            showBiometricErrorAlert = true
            return
        }

        // Test authentication before enabling
        biometricService.unlockWithBiometricsOrPasscode(
            reason: "Authenticate to enable \(biometricService.biometricTypeString) protection",
            onSuccess: {
                // Save preference to database
                Task {
                    let updates = [UserSettingsUpdate.biometrics(true)]
                    let result = await remoteService.updateUserSettings(id: settings.id!, updates: updates)
                    if !result.success, let error = result.error {
                        Crashlytics.crashlytics().record(error: error)
                    }
                }
            },
            onFailure: { error in
                biometricErrorMessage = "Authentication failed: \(error)"
                showBiometricErrorAlert = true
            }
        )
    }

    private func disableBiometric() {
        guard (authService.currentUser?.uid) != nil else {
            biometricErrorMessage = "No authenticated user"
            showBiometricErrorAlert = true
            return
        }

        Task {
            let updates = [UserSettingsUpdate.biometrics(false)]
            let result = await remoteService.updateUserSettings(id: settings.id!, updates: updates)

            if !result.success, let error = result.error {
                Crashlytics.crashlytics().record(error: error)
            }

            // Unlock the app when disabled
            appState.isLocked = false
        }
    }
}
