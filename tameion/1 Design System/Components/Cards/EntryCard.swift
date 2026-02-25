//
//  DSEntryCard.swift
//  tameion
//
//  Created by Shola Ventures on 1/11/26.
//
import SwiftUI

struct DSEntryCard: View {
    let title: String
    let preview: String
    let dateText: String

    init(
        title: String,
        preview: String,
        date: Date
    ) {
        self.title = title
        self.preview = preview
        self.dateText = DSFormatter.relativeDate(date: date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(title)
                .textStyle(.entryBody)
                .lineLimit(1)

            Text(preview)
                .textStyle(.entryBody)
                .lineLimit(3)

            Text(dateText)
                .textStyle(.caption)
                .foregroundColor(DSColor.textSecondary)
        }
        .padding(DSSpacing.md)
        .background(DSColor.surface)
        .cornerRadius(DSRadius.md)
    }
}

#Preview {
    DSEntryCard(
        title: "Hello World",
        preview: "This is a preview",
        date: Date()
    )
}
