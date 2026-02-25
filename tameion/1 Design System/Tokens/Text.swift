//
//  Text.swift
//  tameion
//
//  Created by Shola Ventures on 1/8/26.
//
import SwiftUI

enum DSText {
    case display      // rare, emotional emphasis
    case title        // screen / entry titles
    case heading      // section headers
    case body         // primary long-form text
    case bodyCompact  // secondary paragraphs
    case caption      // metadata, timestamps
    case footnote     // helper / legal / quiet text
}

// MARK: - Font

extension DSText {
    var font: Font {
        switch self {
        case .display:
            return .system(size: 28, weight: .semibold)
        case .title:
            return .system(size: 24, weight: .semibold)
        case .heading:
            return .system(size: 20, weight: .semibold)
        case .body:
            return .system(size: 17, weight: .regular)
        case .bodyCompact:
            return .system(size: 17, weight: .regular)
        case .caption:
            return .system(size: 13, weight: .regular)
        case .footnote:
            return .system(size: 11, weight: .regular)
        }
    }
}

// MARK: - Font Size

extension DSText {
    var fontSize: CGFloat {
        switch self {
        case .display: return 28
        case .title: return 24
        case .heading: return 20
        case .body, .bodyCompact: return 17
        case .caption: return 13
        case .footnote: return 11
        }
    }
}

// MARK: - Line Height & Spacing

extension DSText {
    /// Total desired line height (not spacing)
    var lineHeight: CGFloat {
        switch self {
        case .display:
            return 36
        case .title:
            return 32
        case .heading:
            return 28
        case .body:
            return 26
        case .bodyCompact:
            return 22
        case .caption:
            return 18
        case .footnote:
            return 14
        }
    }

    var lineSpacing: CGFloat {
        switch self {
        case .display, .title, .heading:
            return 4
        case .body:
            return 6
        case .bodyCompact:
            return 4
        case .caption, .footnote:
            return 2
        }
    }
}
