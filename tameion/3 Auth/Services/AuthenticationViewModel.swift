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
    
    var currentUser: User? {
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
            print("❌ Email sign in error: \(error.localizedDescription)")
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
            print("❌ Email sign up error: \(error.localizedDescription)")
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
            print("❌ Delete account error: \(error.localizedDescription)")
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
            print("❌ Apple Sign In failed: \(error.localizedDescription)")
            
        case .success(let authorization):
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                errorMessage = "Failed to get Apple ID credential"
                return
            }
            
            signInWithApple(credential: appleIDCredential)
        }
    }
    
    private func signInWithApple(credential: ASAuthorizationAppleIDCredential) {
        guard let nonce = currentNonce else {
            fatalError("Invalid State: a login callback was received, but no login request was sent.")
        }
        
        guard let appleIDToken = credential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("❌ Unable to serialize Apple ID token")
            errorMessage = "Unable to process Apple ID token"
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
                print("❌ Error authenticating with Apple: \(error.localizedDescription)")
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
            fatalError("No client ID found in Firebase configuration.")
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("❌ Unable to get root view controller")
            errorMessage = "Unable to present Google Sign In"
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
                throw AuthenticationError.tokenError(message: "ID token missing")
            }
            
            try await FirebaseAuthService.shared.signInWithGoogle(
                idToken: idToken.tokenString,
                accessToken: user.accessToken.tokenString
            )
            
            isLoading = false
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Google Sign In error: \(error.localizedDescription)")
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






    
    
    
//  init() {
//    registerAuthStateHandler()
//
//    $flow
//      .combineLatest($email, $password, $confirmPassword)
//      .map { flow, email, password, confirmPassword in
//        flow == .login
//          ? !(email.isEmpty || password.isEmpty)
//          : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
//      }
//      .assign(to: &$isValid)
//  }
//
//  private var authStateHandler: AuthStateDidChangeListenerHandle?
//
//  func registerAuthStateHandler() {
//    if authStateHandler == nil {
//      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
//        self.user = user
//        self.authenticationState = user == nil ? .unauthenticated : .authenticated
//        self.displayName = user?.email ?? ""
//      }
//    }
//  }

//  func switchFlow() {
//    flow = flow == .login ? .signUp : .login
//    errorMessage = ""
//  }
//
//  private func wait() async {
//    do {
//      print("Wait")
//      try await Task.sleep(nanoseconds: 1_000_000_000)
//      print("Done")
//    }
//    catch {
//      print(error.localizedDescription)
//    }
//  }
//
//  func reset() {
//    flow = .login
//    email = ""
//    password = ""
//    confirmPassword = ""
//  }
//}
//
//// MARK: - Email and Password Authentication
//
//extension AuthenticationViewModel {
//  func signInWithEmailPassword() async -> Bool {
//    authenticationState = .authenticating
//    do {
//      try await Auth.auth().signIn(withEmail: self.email, password: self.password)
//      return true
//    }
//    catch  {
//      print(error)
//      errorMessage = error.localizedDescription
//      authenticationState = .unauthenticated
//      return false
//    }
//  }
//
//  func signUpWithEmailPassword() async -> Bool {
//    authenticationState = .authenticating
//    do  {
//      try await Auth.auth().createUser(withEmail: email, password: password)
//      return true
//    }
//    catch {
//      print(error)
//      errorMessage = error.localizedDescription
//      authenticationState = .unauthenticated
//      return false
//    }
//  }
//
//  func signOut() {
//    do {
//        try Auth.auth().signOut()
//        authService.signOut()
//    }
//    catch {
//      print(error)
//      errorMessage = error.localizedDescription
//    }
//  }
//
//  func deleteAccount() async -> Bool {
//    do {
//      try await user?.delete()
//      return true
//    }
//    catch {
//      errorMessage = error.localizedDescription
//      return false
//    }
//  }
//}
//
//// MARK: - Apple Authentication
//
//extension AuthenticationViewModel {
//    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
//        request.requestedScopes = [.email, .fullName]
//        let nonce = authService.randomNonceString()
//        currentNonce = nonce
//        request.nonce = authService.sha256(nonce)
//    }
//    
//    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
//        if case .failure(let error) = result {
//            errorMessage = error.localizedDescription
//            print("Failed to sign in: \(error.localizedDescription)")
//        }
//        else if case .success(let success) = result {
//            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
//                guard let nonce = currentNonce else {
//                    fatalError("Invalid State: a login callback was received, but no login request was sent.")
//                }
//                guard let appleIDToken = appleIDCredential.identityToken else {
//                    print("Unable to fetch Apple ID token")
//                    return
//                }
//                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//                    return
//                  }
//                
//                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
//                                                                        rawNonce: nonce,
//                                                                        fullName: appleIDCredential.fullName)
//                
//                Task {
//                    do {
//                        let result = try await Auth.auth().signIn(with: credential)
//                        print("credentials successfully signed in: \(result.user.uid)")
//                        print("display name is \(result.user.displayName ?? "no name")")
//                        print("email is \(result.user.email ?? "no name")")
//                        authService.currentUser?.displayName = (appleIDCredential.fullName?.familyName ?? "")
//                        await updateDisplayName(for: result.user, with: appleIDCredential)
//                    }
//                    catch {
//                        print("Error authenticating: \(error.localizedDescription)")
//                    }
//                }
//                
//            }
//        }
//        
//        func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
//            if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
//                print("current user is non-empty, don't overwrite.")
//
//                // current user is non-empty, don't overwrite.
//            }
//            else {
//                let changeRequest = user.createProfileChangeRequest()
//                changeRequest.displayName = appleIDCredential.fullName?.givenName
//                do {
//                    try await changeRequest.commitChanges()
//                    self.displayName = Auth.auth().currentUser?.displayName ?? ""
//                    print("credentialed found display name: \(self.displayName)")
//                }
//                catch {
//                    errorMessage = error.localizedDescription
//                    print("Unable to update the user's full name: \(error.localizedDescription)")
//                }
//                
//            }
//        }
//    }
//}
//
//// MARK: - Google Authentication
//enum AuthenticationError: Error {
//    case tokenError(message: String)
//}
//
//extension AuthenticationViewModel {
//    func signInWithGoogle() async -> Bool {
//        guard let clientID = FirebaseApp.app()?.options.clientID else {
//            fatalError("No client ID found in Firebase configuration.")
//        }
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//        
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let window = windowScene.windows.first,
//              let rootViewController = window.rootViewController else {
//            return false
//        }
//        
//        do {
//            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
//            let user = userAuthentication.user
//            guard let idToken = user.idToken else {
//                throw AuthenticationError.tokenError(message: "ID token missing")
//            }
//            let accessToken = user.accessToken
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
//            let result = try await Auth.auth().signIn(with: credential)
//            let firebaseUser = result.user
//            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "no email")")
//            return true
//        }
//        catch {
//            errorMessage = error.localizedDescription
//            print(error.localizedDescription)
//            return false
//        }
//        return false
//    }
//}
