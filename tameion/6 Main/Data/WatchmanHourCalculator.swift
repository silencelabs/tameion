//
//  WatchmanHourCalculator.swift
//  tameion
//
//  Created by Shola Ventures on 1/30/26.
//
import SwiftUI

struct WatchmanHourCalculator {
    static func getHour(from date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)

        // Traditional watchman hours (adjust to your theology)
        switch hour {
        case 18...20: return "1st Hour"
        case 21...23: return "2nd Hour"
        case 0...2: return "3rd Hour"
        case 3...5: return "4th Hour"
        case 6...8: return "5th Hour"
        case 9...11: return "6th Hour"
        case 12...14: return "7th Hour"
        case 15...17: return "8th Hour"
        default: return "Unknown"
        }
    }

    static func getHourRange(from date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)

        // Traditional watchman hours (adjust to your theology)
        switch hour {
        case 18...20: return "1st Hour (6-9 PM)"
        case 21...23: return "2nd Hour (9 PM-12 AM)"
        case 0...2: return "3rd Hour (12-3 AM)"
        case 3...5: return "4th Hour (3-6 AM)"
        case 6...8: return "5th Hour (6-9 AM)"
        case 9...11: return "6th Hour (9 AM-12 PM)"
        case 12...14: return "7th Hour (12-3 PM)"
        case 15...17: return "8th Hour (3-6 PM)"
        default: return "Unknown"
        }
    }
}
