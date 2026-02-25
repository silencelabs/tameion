//
//  FirstJournalView.swift
//  tameion
//
//  Created by Shola Ventures on 1/26/26.
//
import SwiftUI
import FirebaseCrashlytics

struct FirstJournalView: View {

    @EnvironmentObject private var appState: AppState

    @EnvironmentObject private var remoteService: DatabaseService
    @EnvironmentObject private var authService: FirebaseAuthService

    @FocusState private var isNameFocused: Bool
    @State var journalName = ""

    private enum FocusableField: Hashable {
        case email
        case password
        case confirmPassword
    }


    var body: some View {

        ZStack {

            GeometryReader { geo in
                    Image("onboarding.journal2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: geo.size.height * 0.7)
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

                Text(DSCopy.Onboarding.FirstJournal.headline)
                    .textStyle(.title, alignment: .center)

                Text(DSCopy.Onboarding.FirstJournal.subheading)
                    .textStyle(.body, alignment: .center)

                // Email Input
                HStack {
                    DSTextField(placeholder: DSCopy.Onboarding.FirstJournal.journalNamePlaceholder, text: $journalName)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($isNameFocused)
                        .submitLabel(.next)
                }
                .padding(.vertical, DSSpacing.sm)

                DSButton(DSCopy.CTA.continued, role: .primary, isEnabled: !journalName.isEmpty) {
                    isNameFocused = false
                    createJournal()
                    appState.markOnboardingComplete()
                    appState.advanceToNextPhase()
                }
            }
            .padding()

        }
        .onAppear {
            isNameFocused = true
        }
    }

    private func createJournal() {
        guard let userId = authService.currentUser?.uid else {
            Crashlytics.crashlytics().log(DSCopy.Error.NotExpected.noUserId + DSCopy.Error.when + DSCopy.Error.Location.FirstJournalView.createJournal)
            return
        }

        var journal = Journal.empty
        journal.name = journalName
        journal.userId = userId

        Task {
            let result = await remoteService.createJournal(journal)

            if result.success {
                // Only set active journal if creation succeeded
                remoteService.setActiveJournal(journal, userId: userId)
            } else if let error = result.error {
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }

}

struct FirstJournalView_Previews: PreviewProvider {
    static var previews: some View {
        FirstJournalView()
    }
}

