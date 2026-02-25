//
//  LoginView.swift
//  tameion
//
//  Created by Shola Ventures on 1/12/26.
//
import SwiftUI
import Combine
import FirebaseAnalytics

private enum FocusableField: Hashable {
    case email
    case password
    case confirmPassword
}

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) var dismiss

    @FocusState private var focus: FocusableField?

    // Observe the auth service directly for reactive updates
    @ObservedObject private var authService = FirebaseAuthService.shared

    private func loginWithEmailPassword() {
        Task {
            if await viewModel.signInWithEmailPassword() {
                print("✅ Successfully signed in with Email/Password")
                dismiss()
                
                if authService.isAuthenticated {
                    appState.advanceToNextPhase()
                }
            } else {
                print("❌ Email/Password sign in failed")
            }
        }
    }

    var body: some View {
        VStack {
            Image("auth.login")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 300, maxHeight: 400)


            Text(DSCopy.Auth.SignIn.login)
                .textStyle(.title)
                .frame(maxWidth: .infinity, alignment: .leading)


            // Email Input
            HStack {
                DSTextField(placeholder: DSCopy.Auth.SignIn.emailPlaceholder, text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .password
                    }
            }
            .padding(.vertical, DSSpacing.sm)


            // Password Input
            HStack {
                DSSecureField(placeholder: DSCopy.Auth.SignIn.passwordPlaceholder, text: $viewModel.password)
                    .focused($focus, equals: .password)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .confirmPassword
                    }
            }
            .padding(.vertical, DSSpacing.sm)


            // Error Message
            if !viewModel.errorMessage.isEmpty {
                VStack {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color(UIColor.systemRed))
                }
            }


            // Login Button
            DSButton(
                DSCopy.Auth.SignIn.login,
                role: .secondary,
                isLoading: viewModel.authenticationState == .authenticating,
                isEnabled: viewModel.isValid,
                action: loginWithEmailPassword
            )
            .padding(.vertical, DSSpacing.sm)


      .disabled(!viewModel.isValid)
      .frame(maxWidth: .infinity)
      .buttonStyle(.borderedProminent)
        
        // Privacy Promise - Very small text at bottom
        Text(DSCopy.Auth.promise)
            .textStyle(.footnote, alignment: .center)
            .padding([.top, .bottom], 50)

    }
    .listStyle(.plain)
    .padding()
    .analyticsScreen(name: "\(Self.self)")
  }
}


