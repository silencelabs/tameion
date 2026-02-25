//
//  BiometricLockScreen.swift
//  tameion
//
//  Created by Shola Ventures on 2/6/26.
//
import SwiftUI

// MARK: - Lock Screen View

struct BiometricLockScreen: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var biometricService = BiometricAuthService.shared
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isAuthenticating = false

    var body: some View {
        ZStack {
            // Full screen blur background
            Color.black
                .opacity(0.95)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // Lock icon with biometric type
                VStack(spacing: 20) {
                    Image(systemName: biometricService.biometricIcon)
                        .font(.system(size: 80))
                        .foregroundColor(.white)

                    Text("Journal Locked")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Use \(biometricService.biometricTypeString) to unlock")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }

                Spacer()

                // Unlock button
                Button {
                    authenticateUser()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: biometricService.biometricIcon)
                            .font(.headline)
                        Text("Unlock")
                            .font(.headline)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .disabled(isAuthenticating)
                .opacity(isAuthenticating ? 0.6 : 1.0)
                .padding(.horizontal, 40)

                // Error message
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .transition(.opacity)
                }

                Spacer()
                    .frame(height: 60)
            }
        }
        .onAppear {
            // Automatically trigger authentication when lock screen appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                authenticateUser()
            }
        }
    }

    private func authenticateUser() {
        guard !isAuthenticating else { return }

        isAuthenticating = true
        showError = false

        biometricService.unlockWithBiometricsOrPasscode(
            reason: "Unlock your journal",
            onSuccess: {
                isAuthenticating = false
                appState.isLocked = false
            },
            onFailure: { error in
                isAuthenticating = false
                showError = true
                errorMessage = error

                // Hide error after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showError = false
                    }
                }
            }
        )
    }
}

