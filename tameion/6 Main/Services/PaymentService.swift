//
//  PaymentService.swift
//  tameion
//
//  Created by Shola Ventures on 1/14/26.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftUI
import RevenueCat
import Sentry

@MainActor
final class PaymentsService: NSObject, ObservableObject  {
    static let shared = PaymentsService()
    
    @Published private(set) var customerInfo: CustomerInfo?
    @Published private(set) var hasActiveSubscription = false
    @Published private(set) var isPremiumSubscriber = false
    
    private var isConfigured = false
    
    private override init() {
        // Empty init - configuration happens separately
    }
    
    func configure(appUserID: String) {
        guard !isConfigured else {
            return
        }
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "RevenueCatAPIKey") as? String else {
            SentrySDK.capture(message: "RevenueCatAPIKey is not found")
            fatalError("RevenueCatAPIKey not found")
        }
        
        Purchases.configure(withAPIKey: apiKey, appUserID: appUserID)
        isConfigured = true

        self.setupPurchasesListener()
    }
    
    private func setupPurchasesListener() {
        // Listen for ongoing updates
        Purchases.shared.delegate = self
        
        // Get initial state
        Purchases.shared.getCustomerInfo { [weak self] info, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.customerInfo = info
                self.isPremiumSubscriber = info?.entitlements.active.isEmpty == false
            }
        }
    }

    func getSubscriptionName() -> String? {
        guard let activeEntitlements = customerInfo?.entitlements.active.values.first else {
            return "nil"
        }
        return activeEntitlements.identifier
    }

    func getSubscriptionStartDate() -> Date? {
        guard let activeEntitlements = customerInfo?.entitlements.active.values.first else {
            return nil
        }
        return activeEntitlements.latestPurchaseDate
    }

    func getSubscriptionExpirationDate() -> Date? {
        guard let activeEntitlements = customerInfo?.entitlements.active.values.first else {
            return nil
        }
        return activeEntitlements.expirationDate
    }

    func isSubscriptionRenewing() -> Bool {
        guard let activeEntitlements = customerInfo?.entitlements.active.values.first else {
            return false
        }
        return activeEntitlements.willRenew
    }
}

// Implement delegate to get real-time updates
extension PaymentsService: PurchasesDelegate {
    nonisolated func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        Task { @MainActor in
            self.customerInfo = customerInfo
            self.isPremiumSubscriber = customerInfo.entitlements.active.isEmpty == false
        }
    }
}
