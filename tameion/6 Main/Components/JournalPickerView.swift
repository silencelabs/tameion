//
//  JournalPickerView.swift
//  tameion
//
//  Created by Shola Ventures on 1/29/26.
//
import SwiftUI
struct JournalPickerView: View {

    @EnvironmentObject private var remoteService: DatabaseService
    @EnvironmentObject private var authService: FirebaseAuthService

    @State private var pendingSelection: Journal?

    var body: some View {
        Menu {
            ForEach(remoteService.activeJournals) { journal in
                Button {
                    let selection = (journal.id?.isEmpty ?? true) ? Journal.AllJournal : journal
                    remoteService.setActiveJournal(selection, userId: authService.currentUser?.uid)
                    remoteService.startReflectListener(userId: remoteService.currentUserId ?? "")
                } label: {
                    HStack {
                        Text(journal.name).font(.headline)
                        if isSelected(journal) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }

            Divider()

            Button {
                // TODO: Add Journal flow
            } label: {
                Label(DSCopy.Journal.newJournalLabel, systemImage: "plus.circle")
            }

            Button {
                // TODO: Manage Journals flow
            } label: {
                Label(DSCopy.Journal.manageJournalLabel, systemImage: "gearshape")
            }

        } label: {
            HStack(spacing: 4) {
                Text(activeJournalName)
                    .font(.headline)
                    .lineLimit(1)
                    .id(remoteService.currentJournalId)
                    .animation(nil, value: remoteService.currentJournalId)
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
        }
    }

    private var activeJournalName: String {
        remoteService.activeJournal?.name ?? DSCopy.Journal.allJournalLabel
    }

    private func isSelected(_ journal: Journal) -> Bool {
        let currentId = remoteService.activeJournal?.id
        let rowId = journal.id

        // Logic: If both are nil/empty, it's a match. Otherwise, compare IDs.
        let isRowAll = rowId?.isEmpty ?? true
        let isCurrentAll = currentId?.isEmpty ?? true

        return isRowAll ? isCurrentAll : (rowId == currentId)
    }
}
