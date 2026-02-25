//
//  EntryEnums.swift
//  tameion
//
//  Created by Shola Ventures on 2/2/26.
//
import SwiftUI

enum EntryType: String, Codable, CaseIterable {
    case note
    case dream
    case prayer
    case promise
    case instruction
    case testimony
    case praise
    case fast
    case warning
    case interpretation
    case revelation

    var icon: String {
        switch self {
        case .dream: return "moon.stars"
        case .interpretation: return "translate"
        case .prayer: return "hands.sparkles"
        case .promise: return "gift"
        case .revelation: return "lightbulb.max"
        case .instruction: return "pencil.and.list.clipboard"
        case .testimony: return "person.wave.2"
        case .note: return "scroll"
        case .praise: return "hands.sparkles"
        case .fast: return "figure.walk.motion"
        case .warning: return "exclamationmark.triangle.fill"
        }
    }

    var color: Color {
        switch self {
        case .dream, .interpretation: return .purple
        case .prayer, .instruction: return .blue
        case .testimony, .praise: return .yellow
        case .revelation, .promise: return .white
        case .warning: return .orange
        case .note: return .gray
        case .fast: return .red
        }
    }

    var category: String {
        switch self {
        case .dream, .instruction, .revelation, .promise, .warning: return "God -> User"
        case .prayer, .fast, .praise: return "User -> God"
        case .testimony, .note, .interpretation: return "Reflection"
        }
    }
}

enum EntryRelationType: String, Codable {
    case fulfills
    case confirms
    case explains
    case responds_to
    case tests
    case resulted_in
    case interprets
}

enum EntryStatus: String, Codable {
    case not_started            // Default: waiting, open, not started
    case in_progress            // Active now: fasting, ongoing
    case waiting
    case completed              // Completed positively: answered prayer, fulfilled promise, finished fast
    case delayed                // Didn't happen: unanswered prayer, unfulfilled promise
    case abandoned              // Done with it, filed away
}

enum EntryUrgency: String, Codable {
    case low
    case normal
    case urgent
}

enum EffortScale: String, Codable {
    case quick
    case ongoing
    case longterm
}

enum RemembranceCadence: String, Codable {
    case none
    case until_fulfilled
    case periodic
    case annual
    case evergreen
}

enum ReminderCadence: String, Codable {
    case none
    case weekly
    case monthly
    case quarterly
    case annual
}

enum Author: String, Codable {
    case user
    case system
    case ai
    case other
}

struct ReferenceStats: Codable {
    var scriptureCount: Int
    var scripturePreview: [String]
    var symbolCount: Int
    var symbolPreview: [String]
}

struct ResponseStats: Codable {
    var prayerCount: Int
    var praiseCount: Int
    var fastCount: Int
    var obedienceCount: Int
    var testimonyCount: Int
    var confirmationCount: Int
    var interpretationsCount: Int
}

enum EntryBadge: Hashable, Identifiable {
    var id: Self { self }

    // State / attention
    case needsAttention
    case urgent
    case waiting
    case uninterpreted
    case inProgress
    case fulfilled
    case onPrayerList

    // Activity (counts)
    case prayed(Int)
    case praised(Int)
    case confirmed(Int)

    // References
    case scripture(preview: [String])
    case symbols(preview: [String])

    var text: String {
        switch self {
        case .needsAttention: return "Needs Attention"
        case .onPrayerList: return "On Prayer List"
        case .urgent: return "Urgent"
        case .waiting: return "Waiting"
        case .uninterpreted: return "Uninterpreted"
        case .inProgress: return "In Progress"
        case .fulfilled: return "Fulfilled"
        case .prayed(let count): return "Prayed x\(count)"
        case .praised(let count): return "Praised x\(count)"
        case .confirmed(let count): return "Confirmed x\(count)"
        case .scripture(let preview): return "\(preview.joined(separator: ", "))"
        case .symbols(let preview): return "Symbols: \(preview.joined(separator: " "))"
        }
    }

    var color: Color {
        switch self {
        case .symbols, .uninterpreted: return .purple
        case .scripture, .prayed, .onPrayerList: return DSColor.baby_blue
        case .confirmed: return .green
        case .fulfilled, .praised: return .yellow
        case .waiting: return .white
        case .inProgress: return .gray
        case .needsAttention: return .orange
        case .urgent: return .red
        }
    }
}
