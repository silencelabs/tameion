//
//  AppState.swift
//  tameion
//
//  Created by Shola Ventures on 1/11/26.
//
import SwiftUI
import Combine
import FirebaseAuth
import Sentry

@MainActor
final class AppState: ObservableObject {
    @Published var phase: AppPhase = .auth
    @Published var isLocked: Bool = false

    private let biometricService = BiometricAuthService.shared
    private let authService = FirebaseAuthService.shared
    private let remoteService = DatabaseService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupAuthObserver()
        setupAppLifecycleObserver()
    }

    private func setupAuthObserver() {
        // Observe auth service for user changes
        authService.$currentUser
            .sink { [weak self] user in
                guard let self = self else { return }
                self.updatePhase(user: user)
            }
            .store(in: &cancellables)
    }

    private func updatePhase(user: FirebaseAuth.User?) {
        let hasSeenWelcome = UserDefaults.standard.bool(forKey: "hasSeenWelcome")
        if user == nil {
            phase = .auth
            isLocked = false // Reset lock state when signed out
        } else if !hasSeenWelcome {
            remoteService.createActiveUserDetails(userId: user?.uid ?? remoteService.currentUserId ?? "")
            phase = .onboarding
            isLocked = false // Don't lock during onboarding
        } else {
            phase = .main
            lockAppIfNeeded()
        }
    }

    func markOnboardingComplete() {
        UserDefaults.standard.set(true, forKey: "hasSeenWelcome")
    }

    func advanceToNextPhase() {
        let hasSeenWelcome = UserDefaults.standard.bool(forKey: "hasSeenWelcome")

        switch phase {
        case .onboarding:
            // Mark welcome as seen and go to main
            UserDefaults.standard.set(true, forKey: "hasSeenWelcome")
            phase = .main

        case .auth:
            if !hasSeenWelcome {
                remoteService.createActiveUserDetails(userId: (remoteService.currentUserId) ?? "")
                phase = .onboarding
            } else {
                phase = .main
            }

        case .main:
            break
        }
    }

    // MARK: - Lock Screen Logic

    private func setupAppLifecycleObserver() {
        // Lock when app enters background
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                self?.lockAppIfNeeded()
            }
            .store(in: &cancellables)

        // Check lock when app enters foreground
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.checkLockOnForeground()
            }
            .store(in: &cancellables)
    }

    private func lockAppIfNeeded() {
        // Only lock if:
        // 1. User is authenticated
        // 2. User is in main phase (not onboarding or auth)
        // 3. Biometrics are enabled
        guard authService.currentUser != nil, phase == .main else { return }

        // Check if user has biometrics enabled in settings
        Task {
            if let userId = authService.currentUser?.uid {
                let result = await DatabaseService.shared.readUserSettings(userSettingsId: userId)
                if result.success && result.data!.biometricsEnabled {
                    isLocked = true
                }
            }
        }
    }

    private func checkLockOnForeground() {
        // If already locked, do nothing (user needs to unlock)
        guard !isLocked else { return }

        // Lock if biometrics are enabled
        lockAppIfNeeded()
    }

    func unlockApp() {
        guard let userId = authService.currentUser?.uid else {
            return
        }

        // Check if user has biometrics enabled
        Task {
            let result = await DatabaseService.shared.readUserSettings(userSettingsId: userId)
            if result.success && !result.data!.biometricsEnabled {
                isLocked = false
            }
        }

        // Request biometric authentication
        biometricService.unlockWithBiometricsOrPasscode(
            reason: "Unlock your journal",
            onSuccess: { [weak self] in
                self?.isLocked = false
            },
            onFailure: { error_msg in
                SentrySDK.capture(message: "Unlock failed: \(error_msg)")
            }
        )
    }

    /// Force lock the app (useful when user enables biometrics in settings)
    func forceLock() {
        guard authService.currentUser != nil, phase == .main else { return }
        isLocked = true
    }
}
