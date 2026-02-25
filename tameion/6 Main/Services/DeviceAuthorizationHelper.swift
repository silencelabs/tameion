//
//  DeviceAuthorizationHelper.swift
//  tameion
//
//  Created by Shola Ventures on 1/23/26.
//
import Foundation
import UIKit


struct DeviceAuthorizationHelper {

    /// Get the current device's unique identifier
    static var currentDeviceID: String {
        UIDevice.current.identifierForVendor?.uuidString ?? "unknown-device"
    }

    /// Check if current device is authorized to sync
    static func canSync(
        userSettings: UserSettings?,
        isPremium: Bool
    ) -> (allowed: Bool, needsRegistration: Bool) {

        // Premium users can always sync from any device
        if isPremium {
            return (allowed: true, needsRegistration: false)
        }

        // Free users - check device registration
        guard let settings = userSettings else {
            // No settings found - needs registration
            return (allowed: true, needsRegistration: true)
        }

        // Check if device is registered
        if !settings.registeredDeviceID.isEmpty {
            if settings.registeredDeviceID == currentDeviceID {
                // This device is registered
                return (allowed: true, needsRegistration: false)
            } else {
                // Different device is registered
                return (allowed: false, needsRegistration: false)
            }
        } else {
            // No device registered yet - register this one
            return (allowed: true, needsRegistration: true)
        }
    }
}

// MARK: - Sync Authorization Error

enum SyncAuthorizationError: LocalizedError {
    case deviceNotAuthorized
    case premiumRequired
    case networkFailed

    var errorDescription: String? {
        switch self {
        case .deviceNotAuthorized:
            return "This device is not authorized to sync. Upgrade to Premium for multi-device sync."
        case .premiumRequired:
            return "Multi-device sync requires Premium subscription."
        case .networkFailed:
            return "No internet connection"
        }
    }
}

