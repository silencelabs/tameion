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
import Sentry

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
                                        Text(DSCopy.Auth.notAvailable(biometricService.biometricTypeString))
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    } else if settings.biometricsEnabled {
                                        Text(DSCopy.Auth.lockReminder)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text(DSCopy.Auth.protectReminder(biometricService.biometricTypeString))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .disabled(!networkMonitor.isConnected)
                        .padding()
                    }
                    .alert(DSCopy.CTA.enable(biometricService.biometricTypeString), isPresented: $showEnableBiometricAlert) {
                        Button(DSCopy.CTA.cancel, role: .cancel) { }
                        Button(DSCopy.CTA.enable) {
                            enableBiometric()
                        }
                    } message: {
                        Text(DSCopy.Auth.unlockReminder(biometricService.biometricTypeString))
                    }
                    .alert(DSCopy.CTA.disable(biometricService.biometricTypeString), isPresented: $showDisableBiometricAlert) {
                        Button(DSCopy.CTA.cancel, role: .cancel) { }
                        Button(DSCopy.CTA.disable, role: .destructive) {
                            disableBiometric()
                        }
                    } message: {
                        Text(DSCopy.Auth.protectionRemoved(biometricService.biometricTypeString))
                    }
                    .alert(DSCopy.Auth.required, isPresented: $showBiometricErrorAlert) {
                        Button(DSCopy.CTA.ok, role: .cancel) { }
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
            biometricErrorMessage = DSCopy.Auth.noAuthUser
            showBiometricErrorAlert = true
            return
        }

        // Test authentication before enabling
        biometricService.unlockWithBiometricsOrPasscode(
            reason: DSCopy.Auth.protectionEnabled(biometricService.biometricTypeString),
            onSuccess: {
                // Save preference to database
                Task {
                    let updates = [UserSettingsUpdate.biometrics(true)]
                    let result = await remoteService.updateUserSettings(id: settings.id!, updates: updates)
                    if !result.success, let error = result.error {
                        SentrySDK.capture(error: error)
                    }
                }
            },
            onFailure: { error_msg in
                biometricErrorMessage = DSCopy.Auth.protectionFailed(error_msg)
                showBiometricErrorAlert = true
            }
        )
    }

    private func disableBiometric() {
        guard (authService.currentUser?.uid) != nil else {
            biometricErrorMessage = DSCopy.Auth.noAuthUser
            showBiometricErrorAlert = true
            return
        }

        Task {
            let updates = [UserSettingsUpdate.biometrics(false)]
            let result = await remoteService.updateUserSettings(id: settings.id!, updates: updates)

            if !result.success, let error = result.error {
                SentrySDK.capture(error: error)
            }

            // Unlock the app when disabled
            appState.isLocked = false
        }
    }
}
