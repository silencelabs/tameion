//
//  Haptic.swift
//  tameion
//
//  Created by Shola Ventures on 1/9/26.
//
import SwiftUI

enum DSHaptic {
    static func button(_ role: DSButtonRole) {
        #if os(iOS)
        let generator: UIImpactFeedbackGenerator

        switch role {
        case .primary:
            generator = UIImpactFeedbackGenerator(style: .medium)
        case .secondary, .cancel, .external:
            generator = UIImpactFeedbackGenerator(style: .light)
        case .danger:
            generator = UIImpactFeedbackGenerator(style: .heavy)
        }

        generator.prepare()
        generator.impactOccurred()
        #else
        // No haptics on macOS (intentionally no-op)
        #endif
    }
}
