//
//  SwipeEnums.swift
//  tameion
//
//  Created by Shola Ventures on 2/11/26.
//
import SwiftUI

enum SwipeButtonAction {
    case complete
    case share
    case pray
    case praise
    case reflect
    case confirm
    case delete
    case more
    case interpret
}

enum SwipeActionRole {
    case primary(entry: Entry)
    case delete
    case more
    case complete

    var title: String {
        switch self {
        case .primary(let entry):
            switch entry.type {
            case .dream: return "Interpet"
            case .note, .revelation: return "Reflect"
            case .prayer: return "Pray Again"
            case .interpretation: return "Pray"
            case .praise: return "Praise Again"
            case .testimony: return "Share"
            case .instruction, .warning: return "Fulfilled"
            case .fast: return "End Fast"
            case .promise: return "Confirm"
            }
        case .more: return "More"
        case .delete: return "Delete"
        case .complete: return "Complete"
        }
    }

    var action: SwipeButtonAction {
        switch self {
        case .primary(let entry):
            switch entry.type {
            case .dream: return .interpret
            case .note, .revelation: return .reflect
            case .prayer, .interpretation: return .pray
            case .praise: return .praise
            case .testimony: return .share
            case .instruction, .warning, .fast: return .complete
            case .promise: return .confirm
            }
        case .more: return .more
        case .delete: return .delete
        case .complete: return .complete
        }
    }

    var color: Color {
        switch self {
        case .primary(let entry):
            switch entry.type {
            case .dream, .interpretation: return Color.purple
            case .note, .revelation: return DSColor.light_gray_txt
            case .prayer: return DSColor.baby_blue
            case .praise, .testimony, .promise: return DSColor.accent_yellow
            case .instruction, .warning, .fast: return DSColor.green_grass
            }
        case .more: return Color.gray
        case .delete: return Color.red
        case .complete: return DSColor.green_grass
        }
    }

    var icon: String {
        switch self {
        case .primary(let entry):
            switch entry.type {
            case .dream: return "translate"
            case .note, .revelation: return "book.badge.plus"
            case .prayer, .interpretation: return "flame"
            case .praise: return "hands.and.sparkles"
            case .testimony: return "square.and.arrow.up"
            case .instruction, .warning: return "checkmark.circle"
            case .fast: return "flag.pattern.checkered.2.crossed"
            case .promise: return "checkmark.seal"
            }
        case .more: return "ellipsis"
        case .delete: return "trash"
        case .complete: return "checkmark.circle"
        }
    }

    var isDelete: Bool {
        if case .delete = self { return true }
        return false
    }
}
