//
//  DSTextStyle.swift
//
import SwiftUI

enum DSTextStyle {
    // App
    case title
    case body
    
    // Writing
    case entryTitle
    case entryBody
    case quote
    case reflection

    // Guidance
    case prompt
    case placeholder

    // Structure
    case sectionHeader
    case listItem

    // Metadata
    case date
    case metadata
    case caption
    case link

    // System
    case footnote
}

extension DSTextStyle {
    var textToken: DSText {
        switch self {
        case .entryTitle, .title:
            return .title
        case .entryBody, .body:
            return .body
        case .quote:
            return .body
        case .reflection:
            return .body

        case .prompt:
            return .bodyCompact
        case .placeholder:
            return .body

        case .sectionHeader:
            return .heading
        case .listItem:
            return .bodyCompact

        case .date:
            return .caption
        case .metadata:
            return .caption
        case .caption, .link:
            return .caption

        case .footnote:
            return .footnote
        }
    }
}

extension DSTextStyle {
    var color: Color {
        switch self {
        case .entryTitle, .entryBody, .reflection, .title, .body:
            return DSColor.textPrimary

        case .quote:
            return DSColor.textPrimary.opacity(0.9)

        case .prompt:
            return DSColor.textSecondary

        case .placeholder:
            return DSColor.textTertiary

        case .sectionHeader:
            return DSColor.textSecondary

        case .listItem:
            return DSColor.textPrimary

        case .date, .metadata, .caption:
            return DSColor.textTertiary

        case .link:
            return DSColor.mid_blue

        case .footnote:
            return DSColor.textTertiary.opacity(0.8)
        
        }
    }
}

extension DSTextStyle {
    var isItalic: Bool {
        switch self {
        case .quote, .reflection:
            return true
        default:
            return false
        }
    }
}

extension DSTextStyle {
    var isBold: Bool {
        switch self {
        case .entryTitle, .sectionHeader, .title:
            return true
        default:
            return false
        }
    }
}

extension DSTextStyle {
    var isUnderlined: Bool {
        switch self {
        case .link:
            return true
        default:
            return false
        }
    }
}

extension DSTextStyle {
    var alignment: TextAlignment {
        switch self {
        case .title, .body, .caption, .link:
            return TextAlignment.center
        default:
            return TextAlignment.leading
        }
    }
}

extension View {
    func centerStyle() -> some View {
        return self
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    func textStyle(_ style: DSTextStyle, color: Color? = nil, alignment: TextAlignment? = nil) -> some View {
        let token = style.textToken

        return self
            .font(style.isItalic ? token.font.italic() : token.font)
            .multilineTextAlignment((alignment == nil ? style.alignment : alignment)!)
            .foregroundColor(color == nil ? style.color : color)
            .underline(style.isUnderlined)
            .lineSpacing(token.lineSpacing)
            .modifier(
                LineHeightModifier(
                    lineHeight: token.lineHeight,
                    fontSize: token.fontSize
                )
            )
    }
    
    func slimTextStyle(_ style: DSTextStyle, color: Color? = nil, alignment: TextAlignment? = nil) -> some View {
        let token = style.textToken

        return self
            .font(style.isItalic ? token.font.italic() : token.font)
            .multilineTextAlignment((alignment == nil ? style.alignment : alignment)!)
            .foregroundColor(color == nil ? style.color : color)
            .underline(style.isUnderlined)
    }
    
    func buttonTextStyle(_ style: DSTextStyle) -> some View {
        let token = style.textToken

        return self
            .font(style.isItalic ? token.font.italic() : token.font)
            .fontWeight(style.isBold ? .bold : .medium)
            .lineSpacing(token.lineSpacing)
            .modifier(
                LineHeightModifier(
                    lineHeight: token.lineHeight,
                    fontSize: token.fontSize
                )
            )
    }
}

