//
//  OnboardingView.swift
//  tameion
//
//  Created by Shola Ventures on 1/26/26.
//
import SwiftUI
import RevenueCat
import RevenueCatUI
import FirebaseCrashlytics
import Sentry


struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @State private var step: OnboardingPhase = .welcome

    @EnvironmentObject private var remoteService: DatabaseService
    @EnvironmentObject private var emailService: EmailService
    @EnvironmentObject private var authService: FirebaseAuthService
    @EnvironmentObject private var notifyService: NotificationsService

    @State private var userResearch: UserResearch?
    @State private var userSettings: UserSettings?
    @State private var isLoading = true

    var body: some View {
        ZStack {

            if isLoading {
                ProgressView("Loading...")
            }

            switch step {
            case .welcome:
                WelcomeView(onContinue: { step = .questions })
            case .questions:
                QuestionsView(onContinue: { step = .notifications }, userResearch: userResearch!)
            case .notifications:
                NotificationsView(onContinue: { step = .faceID }, userSettings: userSettings!)
            case .faceID:
                SecureView(onContinue: { step = .createJournal }, userSettings: userSettings!)
            case .createJournal:
                FirstJournalView()
                    .presentPaywallIfNeeded(
                        requiredEntitlementIdentifier: "premium",
                        purchaseCompleted: { customerInfo in
                            // 1. Log the successful purchase as a breadcrumb
                            SentrySDK.addBreadcrumb({
                                let crumb = Breadcrumb(level: .info, category: "revenuecat")
                                crumb.message = "Purchase completed: premium"
                                crumb.data = ["entitlements": customerInfo.entitlements.active.keys.joined(separator: ", ")]
                                return crumb
                            }())

                            // 2. Update the Sentry user's global status so future crashes show they are 'premium'
                            SentrySDK.configureScope { scope in
                                scope.setTag(value: "premium", key: "subscription_status")
                            }
                        },
                        restoreCompleted: { customerInfo in
                            // 3. Log the restore as a breadcrumb
                            SentrySDK.addBreadcrumb({
                                let crumb = Breadcrumb(level: .info, category: "revenuecat")
                                crumb.message = "Purchase restored"
                                return crumb
                            }())
                        }
                    )
                    .onAppear {
                        // 4. Track that the paywall check was triggered
                        SentrySDK.addBreadcrumb({
                            let crumb = Breadcrumb(level: .info, category: "ui.lifecycle")
                            crumb.message = "Paywall check triggered for 'premium'"
                            return crumb
                        }())
                    }
            }
        }
        .task {
            await loadUserData()
        }
    }

    private func loadUserData() async {
        guard let userId = authService.currentUser?.uid else {
            Crashlytics.crashlytics().log(DSCopy.Error.NotExpected.noUserId + DSCopy.Error.when + DSCopy.Error.Location.FirstJournalView.createJournal)
            isLoading = false
            return
        }

        Task {
            let result = await remoteService.readUserResearch(id: userId)
            if !result.success, let error = result.error {
                Crashlytics.crashlytics().record(error: error)
                userResearch = UserResearch.empty
                userResearch!.id = userId
            } else {
                userResearch = result.data
            }

            let sResult = await remoteService.readUserSettings(userSettingsId: userId)
            if !sResult.success, let error = sResult.error {
                Crashlytics.crashlytics().record(error: error)
                userSettings = UserSettings.empty
                userSettings!.id = userId
            } else {
                userSettings = sResult.data
            }
        }

        isLoading = false
    }
}
