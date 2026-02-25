//
//  SeekDashboard.swift
//  tameion
//
//  Created by Shola Ventures on 2/4/26.
//
import SwiftUI

struct SeekDashboard: View {

    @EnvironmentObject private var remoteService: DatabaseService

    let sections: [EntryActionSection]
    var filteredSections: [EntryActionSection] {
        // 1. Check if we are in "All Journals" mode (nil or empty ID)
        let isAllJournals = remoteService.currentJournalId?.isEmpty ?? true

        if isAllJournals {
            return sections // Return everything as-is
        }

        // 2. Otherwise, filter specifically for the selected journal
        return sections.map { section in
            let entries = section.entries.filter {
                $0.journalId == remoteService.currentJournalId
            }

            return EntryActionSection(
                title: section.title,
                helper: section.helper,
                color: section.color,
                entries: entries
            )
        }
    }

    var body: some View {

        Section {
            VStack(spacing: DSSpacing.md) {
                HStack(spacing: DSSpacing.md) {
                    ForEach(filteredSections) { section in
                        DashboardTile(
                            value: "\(section.entries.count)",
                            label: section.title,
                            color: section.color
                        )
                    }
                }
            }
//            .padding(.horizontal)
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
