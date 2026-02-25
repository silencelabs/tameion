//
//  tameionApp.swift
//  tameion
//
//  Created by Shola Ventures on 1/8/26.
//

import SwiftUI
import Sentry

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import OneSignalFramework
import SwiftfulRouting

@main
struct tameionApp: App {

    @StateObject private var appState = AppState()
    @StateObject private var networkMonitor = NetworkMonitor.shared
    @StateObject private var authViewModel: AuthenticationViewModel
    @StateObject private var authService = FirebaseAuthService.shared
    @StateObject private var biometricService = BiometricAuthService.shared
    @StateObject private var remoteService = DatabaseService.shared
    @StateObject private var emailService = EmailService.shared
    @StateObject private var notifyService = NotificationsService.shared

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        FirebaseApp.configure()

        let settings = FirestoreSettings()
        settings.cacheSettings = PersistentCacheSettings(sizeBytes: 100 * 1024 * 1024 as NSNumber)
        Firestore.firestore().settings = settings

//        _remoteService = StateObject(wrappedValue: DatabaseService.shared)


        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
//            #if targetEnvironment (simulator)
//                let providerFactory = AppCheckDebugProviderFactory ()
//                // Auth.auth().useEmulator(withHost: "localhost", port: 9099)
//            #else
//                let providerFactory = YourSimpleAppCheckProviderFactory()
//            #endif
//            AppCheck.setAppCheckProviderFactory (providerFactory)
            
        }
        _authViewModel = StateObject(wrappedValue: AuthenticationViewModel())
    }

    var body: some Scene {
        WindowGroup {
            RouterView { _ in
                AppRootView()
                    .onAppear {
                        remoteService.currentUserId = authService.currentUser?.uid
                    }
                    .onChange(of: authService.currentUser?.uid) { _, newUid in
                        remoteService.currentUserId = newUid
                    }
            }
            .environmentObject(appState)
            .environmentObject(networkMonitor)
            .environmentObject(authViewModel)
            .environmentObject(authService)
            .environmentObject(biometricService)
            .environmentObject(remoteService)
            .environmentObject(emailService)
            .environmentObject(notifyService)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        SentrySDK.start { options in
            options.dsn = "https://d0a27ad258d33bf8d122228ca4c4d86b@o4510946481733632.ingest.us.sentry.io/4510946485075968"
            options.debug = true

            // Additional Monitoring
            options.enableAppHangTracking = true // Detects if the main thread freezes
            options.enableWatchdogTerminationTracking = true // Detects OS-level kills
            options.enableNetworkBreadcrumbs = true // Automatically tracks HTTP requests
            options.enableCaptureFailedRequests = true // Captures HTTP errors (e.g., 404, 500)

            // Adds IP for users.
            // For more information, visit: https://docs.sentry.io/platforms/apple/data-management/data-collected/
            options.sendDefaultPii = true

            // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
            // We recommend adjusting this value in production.
            // TODO: LOWER TO 0.1 ONCE READY TO LAUNCH TO SAVE ON COSTS
            options.tracesSampleRate = 1.0

            // Configure profiling. Visit https://docs.sentry.io/platforms/apple/profiling/ to learn more.
            options.configureProfiling = {
                $0.sessionSampleRate = 1.0 // We recommend adjusting this value in production.
                $0.lifecycle = .trace
            }

            // Uncomment the following lines to add more data to your events
            // options.attachScreenshot = true // This adds a screenshot to the error events
            // options.attachViewHierarchy = true // This adds the view hierarchy to the error events
            
            // Enable experimental logging features
            options.experimental.enableLogs = true
        }

        // Enable verbose logging for debugging (remove in production)
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
       
        // Initialize with your OneSignal App ID
        guard let appID = Bundle.main.object(forInfoDictionaryKey: "OneSignalAppID") as? String else {
            fatalError("OneSignalAppID not found")
        }
    
        OneSignal.initialize(appID, withLaunchOptions: launchOptions)
        return true
    }
}

