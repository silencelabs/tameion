//
//  ReflectView.swift
//  tameion
//
//  Created by Shola Ventures on 1/11/26.
//
import SwiftUI

struct ReflectView: View {
    @Environment(\.router) var router

    @EnvironmentObject private var remoteService: DatabaseService
    @EnvironmentObject private var networkMonitor: NetworkMonitor

    @State private var selectedItem: Entry?

    // MARK: - Derived State

    // activeReflectSections is already filtered by the active journal in DatabaseService.
    // No need to re-filter here.
    private var sections: [EntrySection] {
        remoteService.activeReflectSections
    }

    // Nil means the first page hasn't been requested yet (key not in entriesByJournal).
    // Empty array means the page loaded but returned no results.
    private var isFirstPageLoading: Bool {
        let key = remoteService.currentJournalId.flatMap { $0.isEmpty ? nil : $0 } ?? "all"
        return remoteService.entriesByJournal[key] == nil
    }

    // MARK: - Body

    var body: some View {
        ZStack {
//            if isFirstPageLoading {
//                ProgressView("Gathering your entries...")
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//            } else
            if sections.isEmpty {
                emptyStateView
            } else {
                listView
            }
        }
    }

    // MARK: - List

    private var listView: some View {
        List {
            ForEach(sections) { section in
                Section(header: sectionHeader(section.displayTitle)) {
                    ForEach(section.entries) { entry in
                        entryRow(entry)
                            .task(id: entry.id) { // Fires ONLY when this specific ID appears
                                if isLastEntry(entry, in: sections) &&  !remoteService.isReflectLoading {
                                    remoteService.loadMoreEntries()
                                }
                            }
                    }
                }
            }
        }
        .refreshable {
            await refreshReflectData()
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    // MARK: - Row

    private func entryRow(_ entry: Entry) -> some View {
        TimelineRow(card: .reflect, entry: entry)
            .contentShape(Rectangle())
            .onTapGesture {
                router.showScreen(.push) { _ in EntryDetailView(entry: entry) }
            }
            .listRowInsets(EdgeInsets(
                top: DSSpacing.sm, leading: DSSpacing.md,
                bottom: DSSpacing.sm, trailing: DSSpacing.md
            ))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }

    // MARK: - Section Header

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .textCase(.uppercase)
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: DSSpacing.md) {
            Text(DSCopy.ProgressView.noEntries)
                .font(.headline)
            Text(DSCopy.ProgressView.noEntriesEncouragement)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Last Entry

    func isLastEntry(_ entry: Entry, in sections: [EntrySection]) -> Bool {
        guard let lastSection = sections.last,
              let lastEntry = lastSection.entries.last else { return false }
        return entry.id == lastEntry.id
    }

    // MARK: - Refresh

    /// Pull-to-refresh restarts page 1 for the current journal (not appending).
    /// Uses async/await so the spinner dismisses once the first snapshot arrives.
    @MainActor
    private func refreshReflectData() async {
        guard networkMonitor.isConnected,
              let userId = remoteService.currentUserId else { return }
        remoteService.startReflectListener(userId: userId)
        try? await Task.sleep(for: .seconds(1))
    }
}
