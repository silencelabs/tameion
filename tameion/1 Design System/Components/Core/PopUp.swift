//
//  PopUp.swift
//  tameion
//
//  Created by Shola Ventures on 1/11/26.
//
import SwiftUI

struct DSPopup<Content: View>: View {
    let onDismiss: () -> Void
    let content: Content

    init(
        onDismiss: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.onDismiss = onDismiss
        self.content = content()
    }

    var body: some View {
        ZStack {
            DSColor.overlay
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            VStack {
                content
            }
            .padding(DSSpacing.lg)
            .background(DSColor.surface)
            .cornerRadius(DSRadius.lg)
            .padding(DSSpacing.lg)
        }
    }
}


struct DSPopupContent: View {
    let title: String
    let message: String
    let cta: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: DSSpacing.md) {
            Text(title)
                .textStyle(.sectionHeader)

            Text(message)
                .textStyle(.entryBody)
                .multilineTextAlignment(.center)

            DSButton(cta, role: .primary) {
                action()
            }
        }
    }
}

#Preview {
    var showPopup = true
    if showPopup {
        DSPopup {
            showPopup = false
        } content: {
            DSPopupContent(
                title: "Entry Saved",
                message: "Thank you for taking time to reflect with God today.",
                cta: DSCopy.CTA.continued
            ) {
                showPopup = false
            }
        }
    }

}
