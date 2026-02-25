//
//  JournalCard.swift
//  tameion
//
//  Created by Shola Ventures on 1/10/26.
//
import SwiftUI

struct DSJournalCard: View {
    let title: String
    let previewText: String
    let date: Date

    var body: some View {
        DSCard {
            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                Text(title)
                    .textStyle(.entryTitle)

                Text(previewText)
                    .textStyle(.entryBody)
                    .lineLimit(4)

                Text(DSFormatter.relativeDate(date: date))
                    .textStyle(.caption)
                    .foregroundColor(DSColor.textSecondary)
            }
        }
    }
}

#Preview {
    DSJournalCard(title: "Hello", previewText: "World", date: Date())
}
