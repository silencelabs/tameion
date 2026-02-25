//
//  MetadataView.swift
//  tameion
//
//  Created by Shola Ventures on 1/30/26.
//
import SwiftUI

struct MetadataView: View {

    let card: TimelineCardType
    let entry: Entry

    var body: some View {

        // Badges row (scrollable if needed)
        if !entry.badges.isEmpty {
            HStack(spacing: DSSpacing.sm) {
                ForEach(entry.badges, id: \.self) { badge in
                    Text(badge.text)
                        .font(.caption2)
                        .padding(.horizontal, DSSpacing.sm)
                        .padding(.vertical, DSSpacing.xs)
                        .background(badge.color.opacity(0.25))
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                        .overlay(
                                Group {
                                    if badge.text == "Waiting" {
                                        Capsule()
                                            .stroke(Color.gray, lineWidth: 1) // Add the gray border
                                    } else {
                                        EmptyView() // Show nothing otherwise
                                    }
                                }
                            )
                }
            }
        }

        
        // Bottom metadata row: Type • Due Date (if applicable) • Date
        HStack(spacing: DSSpacing.sm) {

            if card == .reflect {
                // Time
                Text(DSFormatter.time(date: entry.createdAt))
                    .font(.caption)
                    .foregroundColor(.secondary)

            } else {

                // Relative Date
                Text(DSFormatter.shortDate(date: entry.createdAt))
                    .font(.caption)
                    .foregroundColor(.secondary)

            }

            // Alert
            if entry.actionRequired && entry.obedienceStatus != EntryStatus.completed && entry.dueDate != nil {
                Text(DSCopy.Timeline.metadataSeparator)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(DSCopy.Timeline.dueDatePrefix + DSFormatter.shortDate(date: entry.dueDate!))
                    .font(.caption)
                    .foregroundColor(DSColor.alert)
            }

            // Entry Type
            Text(DSCopy.Timeline.metadataSeparator)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(entry.type.rawValue.capitalized)
                .font(.caption)
                .foregroundColor(.secondary)



            Spacer()

            // Time Ago badge
            if card == .seek && entry.type != .prayer && entry.type != .praise {
                if !DSFormatter.timeAgo(from: entry.createdAt).isEmpty{
                    Text(DSFormatter.timeAgo(from: entry.createdAt))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
        }
    }
}
