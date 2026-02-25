//
//  SeekView.swift
//  tameion
//
//  Created by Shola Ventures on 1/15/26.
//
import SwiftUI

struct SeekView: View {
    @Environment(\.router) var router
    @EnvironmentObject private var remoteService: DatabaseService
    @EnvironmentObject private var networkMonitor: NetworkMonitor

    @State private var selectedItem: Entry?

    // MARK: - Derived State

    // Seek filters by journal in the UI layer (unlike Reflect which is pre-filtered in the service).
    // activeSeekSections contains ALL actionable entries; we scope them here per the active journal.
    var filteredSections: [EntryActionSection] {
        guard let activeJournalId = remoteService.currentJournalId, !activeJournalId.isEmpty else {
            return remoteService.activeSeekSections
        }

        return remoteService.activeSeekSections
            .map { section in
                EntryActionSection(
                    title:   section.title,
                    helper:  section.helper,
                    color:   section.color,
                    entries: section.entries.filter { $0.journalId == activeJournalId }
                )
            }
            .filter { !$0.entries.isEmpty }
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            if filteredSections.isEmpty {
                emptyStateView
            } else {
                listView
            }
        }
    }

    // MARK: - List

    private var listView: some View {
        List {
            SeekDashboard(sections: filteredSections)

            ForEach(filteredSections) { section in
                Section {
                    ForEach(section.entries) { entry in
                        TimelineRow(card: .seek, entry: entry)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                SwipeAction(entry: entry, role: .complete)
                                SwipeAction(entry: entry, role: .delete)
                            }
                    }
                } header: {
                    HeaderLabel(section: section)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .refreshable {
            await refreshSeekData()
        }
    }

    // MARK: - Empty State

    // Wrapping in a List keeps the pull-to-refresh gesture available even when there's no content.
    private var emptyStateView: some View {
        List {
            VStack(spacing: DSSpacing.md) {
                Text(DSCopy.ProgressView.noFilteredEntries)
                    .font(.headline)
                Text(DSCopy.ProgressView.noFilteredEntriesEncouragement)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 40)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .refreshable {
            await refreshSeekData()
        }
    }

    // MARK: - Refresh

    // Seek doesn't paginate — refresh just restarts the listener which re-fetches all action entries.
    @MainActor
    private func refreshSeekData() async {
        guard networkMonitor.isConnected,
              let userId = remoteService.currentUserId else { return }

        remoteService.startSeekListener(userId: userId)

        // Brief pause to let the first snapshot arrive before dismissing the spinner.
        try? await Task.sleep(for: .seconds(1))
    }
}
