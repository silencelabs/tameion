//
//  DSGlassCard.swift
//  tameion
//
//  Created by Shola Ventures on 1/16/26.
//
import SwiftUI

struct DSGlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            // Glass effect background
            RoundedRectangle(cornerRadius: DSRadius.md)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .background(
                    RoundedRectangle(cornerRadius: DSRadius.md)
                        .fill(Color.white.opacity(0.05))
                )
                .backdrop()
            
            // Border for glass effect
            RoundedRectangle(cornerRadius: DSRadius.md)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.4),
                            Color.white.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
            
            content
                .padding(DSSpacing.md)
        }
        .shadow(
            color: Color.black.opacity(0.1),
            radius: 8,
            x: 0,
            y: 4
        )
    }
}

// Helper for backdrop blur effect
extension View {
    func backdrop() -> some View {
        self
            .background(.ultraThinMaterial)
    }
}
