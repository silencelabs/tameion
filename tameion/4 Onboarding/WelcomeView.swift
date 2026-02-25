//
//  WelcomeView.swift
//  tameion
//
//  Created by Shola Ventures on 1/11/26.
//
import SwiftUI

struct WelcomeView: View {

    @EnvironmentObject private var appState: AppState
    var onContinue: () -> Void

    @State private var currentPage = 0

    /**

     Visual: Hero image (open journal, soft light, minimal/spiritual)

     Headline: "Remember God's Voice"

     Subhead: "Your spiritual journal for dreams, prayers, and promises"

     CTA: "Get Started" (button)

     */

    var body: some View {
        ZStack {
            GeometryReader { geo in
                    Image("onboarding.welcome2")
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


                // Title
                Text(DSCopy.Onboarding.Welcome.headline)
                    .textStyle(.title, alignment: .center)

                // Description
                Text(DSCopy.Onboarding.Welcome.subheading)
                    .textStyle(.body, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, DSSpacing.xxl)

                DSButton(DSCopy.CTA.get_started, role: .primary) {
                    onContinue()
                }

            }
            .padding()
        }


    }

}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(onContinue: {})
    }
}
