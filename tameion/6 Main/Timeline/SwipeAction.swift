//
//  SwipeAction.swift
//  tameion
//
//  Created by Shola Ventures on 2/4/26.
//
import SwiftUI
import FirebaseCrashlytics

struct SwipeAction: View {

    @EnvironmentObject private var remoteService: DatabaseService

    var entry: Entry
    let role: SwipeActionRole

    var body: some View {

        Button(role: (role.isDelete ? .destructive : nil)) {
            handleAction()
        } label: {
            Label(role.title, systemImage: role.icon)
        }
        .tint(role.color)
    }

    private func handleAction() {
        guard let entryId = entry.id else { return }

        // Trigger Haptics for a "Heavy" feel
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()

        Task {
            switch role {
                case .complete:
                    generator.notificationOccurred(.success)
                    let result = await remoteService.updateEntry(id: entryId, updates: [
                        .status(EntryStatus.completed),
                        .actionable(false)
                    ])

                    if !result.success {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.error) // Triple buzz
                    }

                case .delete:
                    // TODO: pop-up to confirm!
                    _ = await remoteService.deleteEntry(id: entry.id!)

                default:
                    _ = await remoteService.deleteEntry(id: entry.id!)
            }
        }

    }

    private func delete(entry: Entry) async {
        let result = await remoteService.deleteEntry(id: entry.id!)
        if !result.success, let error = result.error {
            Crashlytics.crashlytics().record(error: error)
        }
    }

}
