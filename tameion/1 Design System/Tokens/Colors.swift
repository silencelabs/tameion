//
//  DSColors.swift
//  tameion
//
//  Created by Shola Ventures on 1/8/26.
//
import SwiftUI

extension Color {
    init(hex: String, alpha: Double = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64

        switch hex.count {
        case 6: // RRGGBB
            r = (int >> 16) & 0xFF
            g = (int >> 8) & 0xFF
            b = int & 0xFF
        default:
            r = 0
            g = 0
            b = 0
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: alpha
        )
    }
    
    // Converts a SwiftUI Color to a hex string
    func toHexString(includeAlpha: Bool = false) -> String? {
        guard let components = self.cgColor?.components else { return nil }
        
        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)
        
        let hexString: String
        if includeAlpha, let alpha = components.last {
            let alphaValue = Int(alpha * 255.0)
            hexString = String(format: "#%02X%02X%02X%02X", red, green, blue, alphaValue)
        } else {
            hexString = String(format: "#%02X%02X%02X", red, green, blue)
        }
        return hexString
    }
}


enum DSColor {

    // Brand Colors
    static let navy_blue       = Color(hex: "#04215F")
    static let baby_blue       = Color(hex: "#8BD4F3")
    static let yellow_gold     = Color(hex: "#F4CF1E")
    static let mustard_gold    = Color(hex: "#FCAF18")
    static let terracotta      = Color(hex: "#DA6241")
    static let raspberry_red   = Color(hex: "#D5313D")
    static let lilac_purple    = Color(hex: "#C16EAC")
    static let green_grass     = Color(hex: "#05A540")
    static let bright_yellow   = Color(hex: "#F7DF23")
    static let mid_blue        = Color(hex: "#0D96C8")
    static let accent_yellow   = Color(hex: "#E9C15D")

    // Neutral Colors
    static let white            = Color(hex: "#FFFFFF")
    static let off_white_bg     = Color(hex: "#F8F9FA")
    static let off_white_txt    = Color(hex: "#F9FAFB")
    static let light_gray_txt   = Color(hex: "#9CA3AF")
    static let light_gray_border = Color(hex: "#E5E7EB")
    static let gray             = Color(hex: "#6B7280")
    static let dark_gray_border = Color(hex: "#374151")
    static let dark_gray_bg     = Color(hex: "#1F1F1F")
    static let off_black        = Color(hex: "#1F2937")
    static let black            = Color(hex: "#000000")

    // App Semantic Colors
    static let primary        = navy_blue
    static let secondary      = baby_blue
    static let background     = white
    static let alert          = Color.red
    static let textPrimary    = off_black
    static let textSecondary  = gray
    static let textTertiary   = light_gray_txt
    static let textDisabled   = textTertiary.opacity(0.6)
    static let border         = light_gray_border
    static let surface        = off_white_bg
    static let overlay        = black.opacity(0.4)
    static let shadow         = black.opacity(0.08)

}
