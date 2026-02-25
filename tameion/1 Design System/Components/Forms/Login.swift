//
//  Login.swift
//  tameion
//
//  Created by Shola Ventures on 1/9/26.
//
import SwiftUI

struct LoginForm: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var isSubmitting: Bool = false
    @State var canSubmit: Bool = false
    
    
    var body: some View {
        DSForm {
            VStack(spacing: DSSpacing.md) {
                DSTextField(
                    placeholder: "Email",
                    text: $email
                )

                DSTextField(
                    placeholder: "Password",
                    text: $password
                )
            }
        } actions: {
            DSButton(
                "Log In",
                role: .primary,
                isLoading: isSubmitting,
                isEnabled: canSubmit
            ) {
                // action: submit()
            }

            DSButton(
                "Create Account",
                role: .secondary
            ) {
                // action: goToRegister()
            }
        }

    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading) {
            Text("Login Component").font(DSText.title.font)
            LoginForm(canSubmit: true).frame(width: 350)
        }.padding()
    }
}
