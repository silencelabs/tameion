//
//  SecureView.swift
//  tameion
//
//  Created by Shola Ventures on 1/26/26.
//
import SwiftUI
import FirebaseCrashlytics

struct SecureView: View {

    @EnvironmentObject private var appState: AppState
    var onContinue: () -> Void

    @EnvironmentObject private var remoteService: DatabaseService
    @EnvironmentObject private var authService: FirebaseAuthService
    @EnvironmentObject private var biometricService: BiometricAuthService


    @State private var userSettings: UserSettings

    @State private var isChecked = false
    @State private var isLoading = true

    // Biometric state
    @State private var showEnableBiometricAlert = false
    @State private var showDisableBiometricAlert = false
    @State private var showBiometricErrorAlert = false
    @State private var biometricErrorMessage = ""

    init(onContinue: @escaping () -> Void, userSettings: UserSettings) {
        self.userSettings = userSettings
        self.onContinue = onContinue
    }

    var body: some View {
        ZStack {

            GeometryReader { geo in
                    Image("onboarding.bible")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: geo.size.height * 0.6)
                        .clipped()
                        .overlay {

                            // Gradient fade to white
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.white
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                }
                .ignoresSafeArea()

            VStack(spacing: DSSpacing.lg) {

                // Header Logo
                VStack {
                    Image("logo.long-form")
                        .resizable()
                        .scaledToFit()
                }
                .frame(height: 40)

                Spacer()

                Text(DSCopy.Onboarding.Security.headline)
                    .textStyle(.title, alignment: .center)

                Text(DSCopy.Onboarding.Security.subheading)
                    .textStyle(.body, alignment: .center)

//                Toggle(DSCopy.Onboarding.Security.enable_faceid, isOn: $isChecked).padding()
//                    .onChange(of: isChecked) { _, newValue in
//                        Task {
//                            
//                        }
//                    }
                Toggle(isOn: Binding(
                    get: { userSettings.biometricsEnabled },
                    set: { newValue in
                        if newValue {
                            showEnableBiometricAlert = true
                        } else {
                            showDisableBiometricAlert = true
                        }
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
                            } else if userSettings.biometricsEnabled {
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
                .disabled(!biometricService.isAvailable)
                .padding()

                DSButton(DSCopy.CTA.continued, role: .primary) {
                    onContinue()
                }
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
        .padding()
    }

    private func enableBiometric() {
        // Test authentication before enabling
        biometricService.unlockWithBiometricsOrPasscode(
            reason: "Authenticate to enable \(biometricService.biometricTypeString) protection",
            onSuccess: {
                // Save preference to database
                Task {
                    // Update local settings
                    var updatedSettings = userSettings
                    updatedSettings.biometricsEnabled = true
                    updatedSettings.updatedAt = Date()

                    // Save to database
                    let updates = [UserSettingsUpdate.biometrics(true)]
                    let result = await remoteService.updateUserSettings(id: updatedSettings.id!, updates: updates)
                    if !result.success, let error = result.error {
                        Crashlytics.crashlytics().record(error: error)
                    } else {
                        // Update state
                        userSettings = updatedSettings
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

        Task {
            // Update local settings
            var updatedSettings = userSettings
            updatedSettings.biometricsEnabled = false
            updatedSettings.updatedAt = Date()

            // Save to database
            let updates = [UserSettingsUpdate.biometrics(false)]
            let result = await remoteService.updateUserSettings(id: updatedSettings.id!, updates: updates)

            if !result.success, let error = result.error {
                Crashlytics.crashlytics().record(error: error)
            } else {
                // Update state
                userSettings = updatedSettings
            }

            // Unlock the app when disabled
            appState.isLocked = false
        }
    }

}

struct SecureView_Previews: PreviewProvider {
    static var previews: some View {
        SecureView(onContinue: {}, userSettings: UserSettings.empty)
    }
}

