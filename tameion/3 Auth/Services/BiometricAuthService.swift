 //
//  BiometricAuthService.swift
//  tameion
//
//  Created by Shola Ventures on 1/27/26.
//
import LocalAuthentication
import Foundation

@MainActor
final class BiometricAuthService: ObservableObject {

    static let shared = BiometricAuthService()

    @Published private(set) var biometricType: LABiometryType = .none
    @Published private(set) var isAvailable: Bool = false

    private let context = LAContext()

    private init() {
        checkBiometricAvailability()
    }

    // MARK: - Public Methods

    /// Check if biometric authentication is available on the device
    func checkBiometricAvailability() {
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            biometricType = context.biometryType
            isAvailable = true
        } else {
            biometricType = .none
            isAvailable = false
        }
    }

    /// Get the biometric type as a user-friendly string
    var biometricTypeString: String {
        switch biometricType {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        case .opticID:
            return "Optic ID"
        case .none:
            return "Biometrics"
        @unknown default:
            return "Biometrics"
        }
    }

    /// Get the appropriate SF Symbol icon name for the biometric type
    var biometricIcon: String {
        switch biometricType {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        case .opticID:
            return "opticid"
        default:
            return "lock.fill"
        }
    }

    /// Authenticate with biometrics or device passcode
    /// - Parameters:
    ///   - reason: The reason shown to the user for authentication
    ///   - onSuccess: Callback on successful authentication
    ///   - onFailure: Callback on failed authentication with error message
    func unlockWithBiometricsOrPasscode(
        reason: String = DSCopy.Auth.lockJournal,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        let context = LAContext()
        context.localizedCancelTitle = DSCopy.Auth.usePasscode

        var error: NSError?

        // Try biometrics first
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        onSuccess()
                    } else if let error = authError as? LAError {
                        // Handle specific biometric errors
                        switch error.code {
                        case .userCancel, .userFallback:
                            // User chose to use passcode - try device authentication
                            self.authenticateWithPasscode(reason: reason, onSuccess: onSuccess, onFailure: onFailure)

                        case .biometryNotAvailable, .biometryNotEnrolled, .biometryLockout:
                            // Biometrics not available, try passcode directly
                            self.authenticateWithPasscode(reason: reason, onSuccess: onSuccess, onFailure: onFailure)

                        default:
                            onFailure(error.localizedDescription)
                        }
                    } else {
                        onFailure(authError?.localizedDescription ?? DSCopy.Auth.failed)
                    }
                }
            }
        } else {
            // Biometrics not available, try passcode
            authenticateWithPasscode(reason: reason, onSuccess: onSuccess, onFailure: onFailure)
        }
    }

    /// Authenticate with async/await pattern
    /// - Parameter reason: The reason shown to the user for authentication
    /// - Returns: True if authentication was successful
    func authenticate(reason: String = DSCopy.Auth.lockJournal) async -> Bool {
        await withCheckedContinuation { continuation in
            unlockWithBiometricsOrPasscode(
                reason: reason,
                onSuccess: {
                    continuation.resume(returning: true)
                },
                onFailure: { _ in
                    continuation.resume(returning: false)
                }
            )
        }
    }

    // MARK: - Private Methods

    /// Authenticate using device passcode as fallback
    private func authenticateWithPasscode(
        reason: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        let context = LAContext()
        var error: NSError?

        // Check if device passcode is available
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            onFailure(error?.localizedDescription ?? DSCopy.Auth.notAvailable("Device Passcode"))
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authError in
            DispatchQueue.main.async {
                if success {
                    onSuccess()
                } else {
                    onFailure(authError?.localizedDescription ?? DSCopy.Auth.failed)
                }
            }
        }
    }

    /// Test if biometric authentication can be performed (for enabling in settings)
    /// - Returns: True if biometrics are set up and can be used
    func canUseBiometrics() -> Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}
