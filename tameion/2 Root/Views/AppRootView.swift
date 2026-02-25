//
//  AppRootView.swift
//  tameion
//
//  Created by Shola Ventures on 1/9/26.
//
import SwiftUI
import FirebaseCore

struct AppRootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack {
            // Main app content based on phase
            switch appState.phase {
            case .onboarding:
                AdaptiveOnboardingView()

            case .auth:
                AdaptiveAuthView()

            case .main:
                AdaptiveMainView()
            }

            // Lock screen overlay (only shows when locked)
            if appState.isLocked {
                BiometricLockScreen()
                    .transition(.opacity)
                    .zIndex(999) // Ensure it's always on top
            }
        }
        .animation(.easeInOut(duration: 0.2), value: appState.isLocked)
    }
}

#Preview {
    AppRootView()
        .environmentObject(AppState())
}
