//
//  NotificationsView.swift
//  tameion
//
//  Created by Shola Ventures on 1/26/26.
//
//
import SwiftUI
import FirebaseCrashlytics

struct NotificationsView: View {

    @EnvironmentObject private var appState: AppState

    @EnvironmentObject private var remoteService: DatabaseService
    @EnvironmentObject private var notifyService: NotificationsService

    var onContinue: () -> Void
    @State var userSettings: UserSettings

    @State private var reminderTime: Date = Date()
    @State private var isChecked = false


    var body: some View {
        ZStack {

            GeometryReader { geo in
                    Image("onboarding.openbook")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: geo.size.height * 0.6)
                        .clipped()
                        .overlay {

                            // Gradient fade to white
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.white
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                }
                .ignoresSafeArea()

            VStack(spacing: DSSpacing.lg) {

                // Header Logo
                VStack {
                    Image("logo.long-form")
                        .resizable()
                        .scaledToFit()
                }
                .frame(height: 40)

                Spacer()

                Text(DSCopy.Onboarding.Notifications.headline)
                    .textStyle(.title, alignment: .center)

                Text(DSCopy.Onboarding.Notifications.subheading)
                    .textStyle(.body, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)

                VStack {

                    Toggle(DSCopy.Onboarding.Notifications.enable_reminders, isOn: $isChecked).padding()
                        .onChange(of: isChecked) { _, newValue in
                            if newValue {
                                notifyService.requestPermission()

                                if notifyService.isPushNotificationsEnabled() {
                                    userSettings.notificationsEnabled = newValue
                                    userSettings.dailyReminderEnabled = newValue

                                    let timeString = DSFormatter.dateToTimeString(reminderTime)
                                    userSettings.dailyReminderTime = timeString

                                    Task {
                                        let updates = [
                                            UserSettingsUpdate.notifications(newValue),
                                            UserSettingsUpdate.reminder(newValue),
                                            UserSettingsUpdate.reminderTime(timeString)
                                        ]
                                        let result = await remoteService.updateUserSettings(id: userSettings.id!, updates: updates)

                                        if !result.success, let error = result.error {
                                            Crashlytics.crashlytics().record(error: error)
                                        }
                                    }
                                }
                            }
                        }

                    // Daily Reminder Date Picker
                    DatePicker(DSCopy.SettingsView.reminderTime, selection: $reminderTime, displayedComponents: [.hourAndMinute])
                        .padding()
                        .disabled(!isChecked)
                        .opacity(isChecked ? 1.0 : 0.5)
                        .onChange(of: reminderTime) { _, newDate in
                            let timeString = DSFormatter.dateToTimeString(newDate)
                            userSettings.dailyReminderTime = timeString

                            Task {
                                let updates = [UserSettingsUpdate.reminderTime(timeString)]
                                let result = await remoteService.updateUserSettings(id: userSettings.id!, updates: updates)

                                if !result.success, let error = result.error {
                                    Crashlytics.crashlytics().record(error: error)
                                }
                            }
                        }
                }.padding()

                DSButton(DSCopy.CTA.continued, role: .primary) {
                    finalizeSettings()
                    onContinue()
                }
            }
            .padding()

        }
    }

    private func finalizeSettings() {
        if isChecked {
            userSettings.notificationsEnabled = isChecked
            userSettings.dailyReminderEnabled = isChecked

            let timeString = DSFormatter.dateToTimeString(reminderTime)
            let utcString = DSFormatter.dateToUTCString(reminderTime)
            userSettings.dailyReminderTime = timeString
            Task {
                let updates = [UserSettingsUpdate.reminderTime(timeString)]
                let result = await remoteService.updateUserSettings(id: userSettings.id!, updates: updates)
                if !result.success, let error = result.error {
                    Crashlytics.crashlytics().record(error: error)
                } else {
                    await notifyService.schedule(reminderTime: utcString)
                }
            }
        }
    }

}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView(onContinue: {}, userSettings: UserSettings.empty)
    }
}

