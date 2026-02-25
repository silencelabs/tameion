//
//  Untitled.swift
//  tameion
//
//  Created by Shola Ventures on 1/9/26.
//
import SwiftUI

struct InputContainerModifier: ViewModifier {
    let isFocused: Bool

    func body(content: Content) -> some View {
        content
            .padding(DSSpacing.sm)
            .background(DSColor.off_white_bg)
            .clipShape(Capsule())
//            .overlay(
//                RoundedRectangle(cornerRadius: DSSpacing.sm)
//                    .stroke(
//                        isFocused ? DSColor.primary : DSColor.border,
//                        lineWidth: DSSpacing.borderWidth
//                    ).clipShape(Capsule())
//            )
    }
}

struct DSTextField: View {
    let placeholder: String
    @Binding var text: String

    @FocusState private var isFocused: Bool

    var body: some View {
        TextField(placeholder, text: $text)
            .textStyle(.entryBody)
            .textFieldStyle(.plain)
            .padding(.leading)
            .focused($isFocused)
            .modifier(InputContainerModifier(isFocused: isFocused))
    }
}

struct DSSecureField: View {
    let placeholder: String
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .textStyle(.entryBody)
            .textFieldStyle(.plain)
            .padding(.leading)
            .focused($isFocused)
            .modifier(InputContainerModifier(isFocused: isFocused))
    }
}

struct DSJournalEditor: View {
    let placeholder: String
    @Binding var text: String

    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .textStyle(.placeholder)
                    .padding(DSSpacing.md)
            }

            TextEditor(text: $text)
                .textStyle(.entryBody)
                .focused($isFocused)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, DSSpacing.md)
        }
        .modifier(InputContainerModifier(isFocused: isFocused))
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading) {
            Text("TextFields").font(DSText.title.font)
            Spacer()
            DSTextField(placeholder: "What’s been sitting with you today?", text: .constant(""))
        }.padding()
    }
    
}
