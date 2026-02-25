//
//  Form.swift
//  tameion
//
//  Created by Shola Ventures on 1/9/26.
//
import SwiftUI

struct DSForm<Content: View, Actions: View>: View {
    let content: Content
    let actions: Actions

    init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder actions: () -> Actions
    ) {
        self.content = content()
        self.actions = actions()
    }

    var body: some View {
        VStack(spacing: DSSpacing.lg) {
            content

            VStack(spacing: DSSpacing.md) {
                actions
            }
            .padding(.top, DSSpacing.lg)
        }
        .padding(DSSpacing.lg)
    }
}
