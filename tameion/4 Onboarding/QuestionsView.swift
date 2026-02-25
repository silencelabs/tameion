//
//  QuestionsView.swift
//  tameion
//
//  Created by Shola Ventures on 1/26/26.
//
//
import SwiftUI


struct ResearchItem: Identifiable {
    let id = UUID()
    let question: String
    var selection: String
    let answers: [String]
}

struct QuestionsView: View {

    @EnvironmentObject private var appState: AppState
    @State private var selectedItems: [String] = []

    @EnvironmentObject private var remoteService: DatabaseService
    @EnvironmentObject private var emailService: EmailService


    var onContinue: () -> Void
    @State var userResearch: UserResearch



    private let productGoalAnswers = [
        DSCopy.Onboarding.Questions.product_goals.answer_1,
        DSCopy.Onboarding.Questions.product_goals.answer_2,
        DSCopy.Onboarding.Questions.product_goals.answer_3,
        DSCopy.Onboarding.Questions.product_goals.answer_4,
        DSCopy.Onboarding.Questions.product_goals.answer_5,
        DSCopy.Onboarding.Questions.product_goals.answer_6
    ]



    @State private var content: [ResearchItem] = [
        ResearchItem(
            question: DSCopy.Onboarding.Questions.age_range.question,
            selection: DSCopy.Onboarding.Questions.age_range.answer_2, // Initial value
            answers: [
                DSCopy.Onboarding.Questions.age_range.answer_1,
                DSCopy.Onboarding.Questions.age_range.answer_2,
                DSCopy.Onboarding.Questions.age_range.answer_3,
                DSCopy.Onboarding.Questions.age_range.answer_4,
                DSCopy.Onboarding.Questions.age_range.answer_5,
                DSCopy.Onboarding.Questions.age_range.answer_6
            ]
        ),
        ResearchItem(
            question: DSCopy.Onboarding.Questions.journaling_habits.question,
            selection: DSCopy.Onboarding.Questions.journaling_habits.answer_1, // Initial value
            answers: [
                DSCopy.Onboarding.Questions.journaling_habits.answer_1,
                DSCopy.Onboarding.Questions.journaling_habits.answer_2,
                DSCopy.Onboarding.Questions.journaling_habits.answer_3,
                DSCopy.Onboarding.Questions.journaling_habits.answer_4,
                DSCopy.Onboarding.Questions.journaling_habits.answer_5,
                DSCopy.Onboarding.Questions.journaling_habits.answer_6
            ]
        ),
        ResearchItem(
            question: DSCopy.Onboarding.Questions.bible_habits.question,
            selection: DSCopy.Onboarding.Questions.bible_habits.answer_1, // Initial value
            answers: [
                DSCopy.Onboarding.Questions.bible_habits.answer_1,
                DSCopy.Onboarding.Questions.bible_habits.answer_2,
                DSCopy.Onboarding.Questions.bible_habits.answer_3,
                DSCopy.Onboarding.Questions.bible_habits.answer_4,
                DSCopy.Onboarding.Questions.bible_habits.answer_5,
                DSCopy.Onboarding.Questions.bible_habits.answer_6
            ]
        )
    ]

    // Computed property to check if all required fields are selected
    private var isFormValid: Bool {

        // Check that exactly 2 product goals are selected
        return selectedItems.count >= 1
    }

    var body: some View {

        ZStack {

            GeometryReader { geo in
                Image("onboarding.questions")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: geo.size.height * 0.56)
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

                Text(DSCopy.Onboarding.Questions.headline)
                    .textStyle(.title, alignment: .center)

                ScrollView {
                    VStack {
                        ForEach($content) { $item in
                            Text(item.question).textStyle(.body).bold()

                            Spacer()

                            // 3. Bind the picker selection directly to the item's selection property
                            Picker(item.question, selection: $item.selection) {
                                ForEach(item.answers, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                            .tint(.black)
                        }

                        HStack {
                            Text(DSCopy.Onboarding.Questions.product_goals.question)
                                .textStyle(.body).bold()
                            Text("Select 3 Max").textStyle(.caption)
                        }

                        ForEach(productGoalAnswers, id: \.self) { option in
                            Button(action: {
                                toggleSelection(for: option)
                            }) {
                                HStack {
                                    Text(option).textStyle(.body, alignment: .center)
                                    if selectedItems.contains(option) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            .foregroundColor(.primary) // Keep text color normal
                        }
                    }.padding()
                }

                Spacer()

                DSButton(DSCopy.CTA.continued, role: .primary, isEnabled: isFormValid) {
                    saveDataAndScheduleEmail()
                }
            }
            .padding()

        }
    }

    private func toggleSelection(for option: String) {
        if let index = selectedItems.firstIndex(of: option) {
            // Remove if already selected
            selectedItems.remove(at: index)
        } else {
            // Add ONLY if under the limit of 3
            if selectedItems.count < 3 {
                selectedItems.append(option)
            }
        }
    }

    private func saveDataAndScheduleEmail() {

        if content.count >= 3 {
            userResearch.ageRange = content[0].selection
            userResearch.journalingHabits = content[1].selection
            userResearch.bibleHabits = content[2].selection
        }
        userResearch.productGoals = selectedItems

        Task {
            // Schedule the email with the collected data
            emailService.sendWelcome()

            // TODO: Complete this
            _ = await remoteService.updateUserResearch(id: userResearch.id!, updates: [])
        }

        // Call the continue callback
        onContinue()
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView(onContinue: {}, userResearch: UserResearch.empty)
    }
}
