//
//  SignupViwq.swift
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

struct SignupView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    // Observe the auth service directly for reactive updates
    @ObservedObject private var authService = FirebaseAuthService.shared

    @FocusState private var focus: FocusableField?

    private func signUpWithEmailPassword() {
        Task {
            if await viewModel.signUpWithEmailPassword() {
                print("✅ Successfully signed up with Email/Password")
                dismiss()
                
                if authService.isAuthenticated {
                    appState.advanceToNextPhase()
                }
            } else {
                print("❌ Email/Password sign up failed")
            }
        }
    }

    var body: some View {
        VStack {
            Image("auth.signup")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 200, maxHeight: 300)

            Text(DSCopy.Auth.SignIn.signUp)
                .textStyle(.title)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Name Input
            HStack {
                DSTextField(placeholder: DSCopy.Auth.SignIn.namePlaceholder, text: $viewModel.fullName)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .email
                    }
            }
            .padding(.vertical, DSSpacing.sm)


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

            
            // Confirm Password Input
            HStack {
                DSSecureField(placeholder:  DSCopy.Auth.SignIn.confirmPasswordPlaceholder, text: $viewModel.confirmPassword)
                    .focused($focus, equals: .confirmPassword)
                    .submitLabel(.go)
                    .onSubmit {
                        signUpWithEmailPassword()
                    }
            }
            .padding(.vertical, DSSpacing.sm)


            if !viewModel.errorMessage.isEmpty {
                VStack {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color(UIColor.systemRed))
                }
            }
            
            DSButton(
                DSCopy.Auth.SignIn.signUp,
                role: .secondary,
                isLoading: viewModel.authenticationState == .authenticating,
                isEnabled: viewModel.isValid,
                action: signUpWithEmailPassword
            )
            .padding(.vertical, DSSpacing.sm)
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

struct SignupView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SignupView()
      SignupView()
        .preferredColorScheme(.dark)
    }
    .environmentObject(AuthenticationViewModel())
  }
}

