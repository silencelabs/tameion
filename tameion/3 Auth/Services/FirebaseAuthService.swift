//
//  FirebaseAuthService.swift
//  tameion
//
//  Created by Shola Ventures on 1/11/26.
//
import FirebaseAuth
import CryptoKit
import Combine
import RevenueCat
import LocalAuthentication
import Sentry


@MainActor
final class FirebaseAuthService: ObservableObject {
    
    // MARK: - Singleton
    static let shared = FirebaseAuthService()
    
    // MARK: - Published State (Read-Only)
    @Published private(set) var currentUser: FirebaseAuth.User?

    // MARK: - Computed Properties for Easy Access
    var isAuthenticated: Bool {
        currentUser != nil
    }
    
    var userId: String? {
        currentUser?.uid
    }
    
    var email: String? {
        currentUser?.email
    }
    
    var displayName: String? {
        currentUser?.displayName
    }
    
    var photoURL: URL? {
        currentUser?.photoURL
    }
    
    // MARK: - Private Properties

    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Initialization

    private init() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            Task { @MainActor in
                self.currentUser = user
                if let user = user {
                    let sentryUser = Sentry.User()
                    sentryUser.userId = user.uid
                    SentrySDK.setUser(sentryUser)
                    PaymentsService.shared.configure(appUserID: user.uid)
                }
            }
        }
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    
    // MARK: - Public Methods

    func unlockWithFaceID(onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "This is for security reasons.") { success, AuthenticationError in
                
                if success {
                    onSuccess()
                } else {
                    let errorMessage = AuthenticationError?.localizedDescription ?? "There was a problem!"
                    onFailure(errorMessage)
                }
            }
        } else {
            let errorMessage = error?.localizedDescription ?? "Biometrics not available"
            onFailure(errorMessage)
        }
    }
    
    /// Create a new user account with email and password
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    /// - Throws: Firebase auth errors
    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    /// Sign in with email and password
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    /// - Returns: True if successful
    /// - Throws: Firebase auth errors
    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    /// Sign in with Google credential
    /// - Parameters:
    ///   - idToken: Google ID token string
    ///   - accessToken: Google access token string
    /// - Throws: Firebase auth errors
    func signInWithGoogle(idToken: String, accessToken: String) async throws {
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: accessToken
        )
        
        _ = try await Auth.auth().signIn(with: credential)
    }
    
    /// Sign in with Apple ID credential
    /// - Parameters:
    ///   - idToken: The Apple ID token string
    ///   - nonce: The raw nonce used for the request
    ///   - fullName: Optional full name from Apple credential
    /// - Throws: Firebase auth errors
    func signInWithApple(idToken: String, nonce: String, fullName: PersonNameComponents?) async throws {
        let firebaseCredential = OAuthProvider.appleCredential(
            withIDToken: idToken,
            rawNonce: nonce,
            fullName: fullName
        )
        
        let result = try await Auth.auth().signIn(with: firebaseCredential)

        // Update display name if this is a new user
        if let fullName = fullName,
           let givenName = fullName.givenName,
           result.user.displayName?.isEmpty ?? true {
            try? await updateDisplayName(givenName)
        }
    }
    
    /// Sign out the current user
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            SentrySDK.capture(error: error)
        }
    }
    
    /// Delete the current user's account
    /// - Throws: Firebase auth errors or AuthServiceError if no user
    func deleteAccount() async throws {
        guard let user = currentUser else {
            throw AuthServiceError.noAuthenticatedUser
        }
        
        try await user.delete()
    }
    
    
    /// Update the display name for the current user
    /// - Parameter name: The new display name
    func updateDisplayName(_ name: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthServiceError.noAuthenticatedUser
        }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
        
        // Refresh current user to trigger @Published update
        self.currentUser = Auth.auth().currentUser
    }
    
    /// Update the photo URL for the current user
    /// - Parameter url: The new photo URL
    func updatePhotoURL(_ url: URL) async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthServiceError.noAuthenticatedUser
        }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.photoURL = url
        try await changeRequest.commitChanges()
        
        // Refresh current user to trigger @Published update
        self.currentUser = Auth.auth().currentUser
    }
    
    // MARK: - Helper Methods for Apple Sign In
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            SentrySDK.capture(message: "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

// MARK: - Error Types

enum AuthServiceError: LocalizedError {
    case noAuthenticatedUser
    
    var errorDescription: String? {
        switch self {
        case .noAuthenticatedUser:
            return DSCopy.Auth.noAuthUser
        }
    }
}
