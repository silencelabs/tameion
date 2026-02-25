//
//  AuthView.swift
//  tameion
//
//  Created by Shola Ventures on 1/11/26.
//
import SwiftUI
import AuthenticationServices
import GoogleSignInSwift
import SwiftfulRouting

struct AuthView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @EnvironmentObject private var appState: AppState
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.router) var router
    
    // Observe the auth service directly for reactive updates
    @ObservedObject private var authService = FirebaseAuthService.shared
    
    var body: some View {
        VStack(spacing: DSSpacing.md) {

            // Header Logo
            VStack {
                Image("logo.long-form")
                    .resizable()
                    .scaledToFit()
            }
            .frame(height: 40)
            
            Spacer()
                
            // Main Image
            VStack {
                Image("auth.welcome")
                    .resizable()
                    .scaledToFit()
            }
            .frame(height: 150)
            
                
            // Title
            Text(DSCopy.Auth.welcome)
                .textStyle(.title, alignment: .center)
            
            // Description
            Text(DSCopy.Auth.subheading)
                .textStyle(.body, alignment: .center)
                .fixedSize(horizontal: false, vertical: true)
                
            // Sign In Buttons
            signInOptionsView
            
            // Register Link
            HStack {
                Text(DSCopy.Auth.SignIn.noAccount)
                    .textStyle(.caption, color: DSColor.black, alignment: .center)
                
                Text(DSCopy.Auth.SignIn.register)
                    .textStyle(.link)
                    .onTapGesture {
                           router.showScreen(.push) { _ in
                               SignupView()
                           }
                      }
            }

            // Privacy Promise - Very small text at bottom
            Text(DSCopy.Auth.promiseAbbreviated)
                .textStyle(.footnote, alignment: .center)
                .padding(.bottom, DSSpacing.sm)
            
            Spacer()
        }
        .padding()
    }

    // MARK: - Sign In Options View

    private var signInOptionsView: some View {
        VStack(spacing: 12) {
            
            // Error Message
            if !viewModel.errorMessage.isEmpty {
                Text(DSCopy.Error.genericBody)
                    .textStyle(.caption, color: .red, alignment: .center)
            } else {
                Text(" ")
            }


            // Loading Indicator
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 8)
            }


            // Email/Password Sign In
            Button(action: {
                viewModel.setFlow(flowState: .login)
                router.showScreen(.push) { _ in
                    LoginView()
                }
            }) {
                Text(DSCopy.Auth.SignIn.withEmail)
                    .buttonTextStyle(.entryBody)
            }
            .buttonStyle(SecondaryButtonStyle())


            // Apple Sign In Button
            SignInWithAppleButton(.signIn) { request in
                requestSignInWithApple(request: request)
            } onCompletion: { result in
                signInWithApple(result: result)
            }
            .frame(height: 50)
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .clipShape(Capsule())


            // Google Sign In Button
            DSButton(
                DSCopy.Auth.SignIn.withGoogle,
                image: DSCopy.Assets.Logos.google,
                role: .external
            ) {
                signInWithGoogle()
            }
            .foregroundColor(colorScheme == .dark ? .white : .black)
        }
    }
    
    func requestSignInWithApple(request: ASAuthorizationAppleIDRequest) {
        viewModel.handleSignInWithAppleRequest(request)
    }
    
    func signInWithApple(result: Result<ASAuthorization, Error>) {
        viewModel.handleSignInWithAppleCompletion(result)
        
        // Advance if successful
        if authService.isAuthenticated {
            appState.advanceToNextPhase()
        }
    }
    
    
    func signInWithGoogle() {
        Task {
            if await viewModel.signInWithGoogle() {
                if authService.isAuthenticated {
                    appState.advanceToNextPhase()
                }
            }
        }
    }
}



// MARK: - Preview

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(AppState())
    }
}
