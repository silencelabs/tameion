//
//  Register.swift
//  tameion
//
//  Created by Shola Ventures on 1/9/26.
//
import SwiftUI

struct RegisterView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var isSubmitting: Bool = false
    @State var canSubmit: Bool = false
    
    var body: some View {
        DSForm {
            VStack(spacing: DSSpacing.md) {
                DSTextField(placeholder: "Email", text: $email)
                DSTextField(placeholder: "Password", text: $password)
                DSTextField(placeholder: "Confirm Password", text: $confirmPassword)
            }
        } actions: {
            DSButton(
                "Create Account",
                role: .primary,
                isLoading: isSubmitting,
                isEnabled: canSubmit
            ) {
                // action: register()
            }

            DSButton(
                "Cancel",
                role: .cancel
            ) {
                // action: dismiss()
            }
        }
    }
}


#Preview {
    ScrollView {
        VStack(alignment: .leading) {
            Text("Login Component").font(DSText.title.font)
            RegisterView(canSubmit: true).frame(width: 350)
        }.padding()
    }
}
