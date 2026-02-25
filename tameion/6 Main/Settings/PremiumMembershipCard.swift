//
//  PremiumMembershipCard.swift
//  tameion
//
//  Created by Shola Ventures on 1/16/26.
//
import SwiftUI
import RevenueCat
import RevenueCatUI

struct PremiumMembershipCard: View {
    @Environment(\.router) var router
    @State private var subscriberBadge: UIImage?

    var body: some View {
        ZStack {
            HStack(alignment: .top, spacing: DSSpacing.md) {
                if PaymentsService.shared.isPremiumSubscriber {
                    Image(uiImage: subscriberBadge ?? UIImage(resource: .paymentsSubscriberBadge))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 15, height: 45)
                        .padding(.horizontal, DSSpacing.lg)
                        .padding(.top, DSSpacing.sm)
                } else {
                    Image(uiImage: subscriberBadge ?? UIImage(resource: .paymentsNonSubscriberBadge))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 15, height: 45)
                        .padding(.horizontal, DSSpacing.lg)
                        .padding(.top, DSSpacing.sm)
                }
                
                VStack(alignment: .leading) {

                    if PaymentsService.shared.isPremiumSubscriber {
                        Text(DSCopy.SettingsView.Payments.premiumSubscriberTitle)
                            .textStyle(.title)
                        if let planName = PaymentsService.shared.getSubscriptionName() {
                            Text(planName).slimTextStyle(.body)
                        }

                        if let startDate = PaymentsService.shared.getSubscriptionStartDate() {
                            Text(DSCopy.SettingsView.Payments.joinedPrefix + DSFormatter.date(date: startDate))
                                .slimTextStyle(.body)
                        }
                        if let expiredDate = PaymentsService.shared.getSubscriptionExpirationDate() {
                            Text(DSCopy.SettingsView.Payments.activePrefix + DSFormatter.date(date: expiredDate))
                                .slimTextStyle(.body)
                        }
                        let willRenew = PaymentsService.shared.isSubscriptionRenewing()
                        HStack {
                            Image(systemName: DSCopy.SettingsView.Payments.subscriptionRenewImage)
                            Text(willRenew ? DSCopy.SettingsView.Payments.autoRenewOn : DSCopy.SettingsView.Payments.autoRenewOff)
                                .textStyle(.caption)
                        }
                    } else {
                        Text(DSCopy.SettingsView.Payments.nonSubscriberTitle)
                            .textStyle(.title)
                        Text(DSCopy.SettingsView.Payments.featureDescription1)
                            .slimTextStyle(.body)
                        Text(DSCopy.SettingsView.Payments.featureDescription2)
                            .slimTextStyle(.body)
                        Text(DSCopy.SettingsView.Payments.featureDescription3)
                            .slimTextStyle(.body)
                        Text(DSCopy.SettingsView.Payments.featureDescription4)
                            .slimTextStyle(.body)
                        Text(DSCopy.SettingsView.Payments.upgradeSubscription)
                            .textStyle(.link)
                            .onTapGesture {
                                router.showScreen(.sheet) { _ in
                                    PaywallView()

                                    // if successful, send sub receipt to email, switch view to premium
                                    // if error email, send email. send abandoned cart email in 7 days
                                }
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

