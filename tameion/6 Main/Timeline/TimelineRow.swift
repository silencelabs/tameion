//
//  TimelineRow.swift
//  tameion
//
//  Created by Shola Ventures on 1/29/26.
//
import SwiftUI

enum TimelineCardType {
    case reflect
    case seek
}

struct TimelineRow: View {
    @Environment(\.router) var router

    let card: TimelineCardType
    let entry: Entry

    var body: some View {

        HStack(alignment: .top, spacing: DSSpacing.md) {
            ZStack {

                VStack(alignment: .leading, spacing: DSSpacing.sm) {

                    // Title
                    Text(entry.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Preview Text
                    Text(entry.previewText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)

                    // Badges and Scannable Info
                    MetadataView(card: card, entry: entry)

                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            router.showScreen(.push) { _ in
                // Navigate to entry detail
                EntryDetailView(entry: entry)
            }
        }
        .listRowInsets(EdgeInsets(
            top: DSSpacing.sm,
            leading: DSSpacing.md,
            bottom: DSSpacing.sm,
            trailing: DSSpacing.md
        ))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)

    }

}
