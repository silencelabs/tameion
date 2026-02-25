//
//  tameionApp.swift
//  tameion
//
//  Created by Shola Ventures on 1/8/26.
//

import SwiftUI
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

