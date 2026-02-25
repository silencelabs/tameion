//
//  AuthenticationViewModel.swift
//  tameion
//
//  Created by Shola Ventures on 1/12/26.
//
import Foundation
import FirebaseAuth
import FirebaseCore
import AuthenticationServices
import GoogleSignIn
import GoogleSignInSwift
import Combine
import Sentry

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    
    // MARK: - Published Properties (UI State)
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var flow: AuthenticationFlow = .signUp
    @Published var valid = false
    @Published var errorMessage = ""
    @Published var isLoading = false
    
    @Published var authenticationState: AuthenticationState = .unauthenticated

    // MARK: - Dependencies
    private let authService = FirebaseAuthService.shared
    private var cancellables = Set<AnyCancellable>()


    // MARK: - Computed Properties (Expose Service State)
    var isAuthenticated: Bool {
        authService.isAuthenticated
    }
    
    var currentUser: FirebaseAuth.User? {
        authService.currentUser
    }
    
    var displayName: String {
        authService.displayName ?? authService.email ?? ""
    }
    

    // MARK: - Private Properties

    private var currentNonce: String?
    

    // MARK: - Initialization

    init() {
        setupFormValidation()
    }
    
    // MARK: - Setup

    private func setupFormValidation() {
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                    ? !email.isEmpty && !password.isEmpty
                    : !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword
            }
            .assign(to: &$valid)
    }
    
    var isValid: Bool {
        if flow == .login {
            return !email.isEmpty &&
            email.contains("@") &&
            email.contains(".") &&
            !password.isEmpty
        } else if flow == .signUp {
            return !email.isEmpty &&
            email.contains("@") &&
            !password.isEmpty &&
            password.count >= 6 &&  // or whatever your requirement is
            password == confirmPassword &&
            !fullName.isEmpty
        }
        return false
    }
    
    // MARK: - Public Methods
    
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
    }
    
    func setFlow(flowState: AuthenticationFlow) {
        reset()
        flow = flowState
    }
    
    func reset() {
        flow = .login
        fullName = ""
        email = ""
        password = ""
        confirmPassword = ""
        errorMessage = ""
        isLoading = false
    }
}



// MARK: - Email and Password Authentication

extension AuthenticationViewModel {
    
    func signInWithEmailPassword() async -> Bool {
        isLoading = true
        errorMessage = ""
        
        do {
            try await FirebaseAuthService.shared.signIn(email: email, password: password)
            isLoading = false
            return true
        } catch {
            SentrySDK.capture(error: error)
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        isLoading = true
        errorMessage = ""
        
        do {
            try await FirebaseAuthService.shared.signUp(email: email, password: password)
            isLoading = false
            return true
        } catch {
            SentrySDK.capture(error: error)
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func signOut() {
        authService.signOut()
        reset()
    }
    
    func deleteAccount() async -> Bool {
        isLoading = true
        errorMessage = ""
        
        do {
            try await FirebaseAuthService.shared.deleteAccount()
            isLoading = false
            return true
        } catch {
            SentrySDK.capture(error: error)
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
}

// MARK: - Apple Sign In

extension AuthenticationViewModel {
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email, .fullName]
        let nonce = authService.randomNonceString()
        currentNonce = nonce
        request.nonce = authService.sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .failure(let error):
            errorMessage = error.localizedDescription
            SentrySDK.capture(error: error)

        case .success(let authorization):
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                errorMessage = DSCopy.Auth.Apple.failedCred
                return
            }
            
            signInWithApple(credential: appleIDCredential)
        }
    }
    
    private func signInWithApple(credential: ASAuthorizationAppleIDCredential) {
        guard let nonce = currentNonce else {
            SentrySDK.capture(message: DSCopy.Auth.Apple.invalidState)
            fatalError(DSCopy.Auth.Apple.invalidState)
        }
        
        guard let appleIDToken = credential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            errorMessage = DSCopy.Auth.Apple.failedToProcess
            SentrySDK.capture(message: errorMessage)
            return
        }
        
        Task {
            isLoading = true
            errorMessage = ""
            
            do {
                try await FirebaseAuthService.shared.signInWithApple(
                    idToken: idTokenString,
                    nonce: nonce,
                    fullName: credential.fullName
                )
                isLoading = false
            } catch {
                SentrySDK.capture(error: error)
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}

// MARK: - Google Sign In

extension AuthenticationViewModel {
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            SentrySDK.capture(message: errorMessage)
            fatalError(DSCopy.Auth.Google.missingConfiguration)
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            errorMessage = DSCopy.Auth.Google.failedToProcess
            SentrySDK.capture(message: errorMessage)
            return false
        }
        
        isLoading = true
        errorMessage = ""
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: rootViewController
            )
            
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                throw AuthenticationError.tokenError(message: DSCopy.Auth.Google.missingToken)
            }
            
            try await FirebaseAuthService.shared.signInWithGoogle(
                idToken: idToken.tokenString,
                accessToken: user.accessToken.tokenString
            )
            
            isLoading = false
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            SentrySDK.capture(error: error)
            isLoading = false
            return false
        }
    }
}

// MARK: - Error Types

enum AuthenticationError: LocalizedError {
    case tokenError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .tokenError(let message):
            return message
        }
    }
}

