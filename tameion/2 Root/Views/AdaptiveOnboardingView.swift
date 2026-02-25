//
//  AdaptiveOnboardingView.swift
//  tameion
//
//  Created by Shola Ventures on 1/21/26.
//
import SwiftUI

struct AdaptiveOnboardingView: View {
    @Environment(\.horizontalSizeClass) private var hSize

    var body: some View {
        if hSize == .regular {
            CenteredContainer {
                OnboardingView()
            }
        } else {
            OnboardingView()
        }
    }
}
