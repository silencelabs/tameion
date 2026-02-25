//
//  ButtonStyles.swift
//  tameion
//
//  Created by Shola Ventures on 1/9/26.
//
import SwiftUI

struct CoreButtonModifier<Background: View>: ViewModifier {
    let background: Background
    let borderColor: Color?
    let borderWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .font(DSText.body.font)
            .padding(DSSpacing.sm)
            .frame(maxWidth: .infinity)
            .background(background)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(borderColor ?? .clear, lineWidth: borderWidth)
            )
    }
}

extension View {
    func coreButtonStyle<Background: View>(
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0,
        @ViewBuilder background: () -> Background
    ) -> some View {
        self.modifier(
            CoreButtonModifier(
                background: background(),
                borderColor: borderColor,
                borderWidth: borderWidth
            )
        )
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .coreButtonStyle {
                DSColor.primary
                    .opacity(configuration.isPressed ? 0.8 : 1)
            }
            .foregroundColor(DSColor.off_white_txt)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .coreButtonStyle {
                DSColor.secondary
                    .opacity(configuration.isPressed ? 0.8 : 1)
            }
            .foregroundColor(DSColor.primary)
    }
}

struct CancelButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .coreButtonStyle(
                borderColor: DSColor.primary,
                borderWidth: DSSpacing.borderWidth
            ) {
                DSColor.off_white_bg
                    .opacity(configuration.isPressed ? 0.8 : 1)
            }
            .foregroundColor(DSColor.primary)
    }
}

struct DangerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .coreButtonStyle {
                DSColor.raspberry_red
                    .opacity(configuration.isPressed ? 0.8 : 1)
            }
            .foregroundColor(DSColor.off_white_txt)
    }
}

struct ExternalButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .coreButtonStyle(
                borderColor: DSColor.light_gray_border,
                borderWidth: DSSpacing.borderWidth
            ) {
                DSColor.off_white_bg
                    .opacity(configuration.isPressed ? 0.8 : 1)
            }
            .foregroundColor(DSColor.primary)
    }
}

