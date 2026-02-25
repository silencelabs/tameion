//
//  CenteredContainer.swift
//  tameion
//
//  Created by Shola Ventures on 1/21/26.
//
import SwiftUI

struct CenteredContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack {
            Spacer()
            content
                .frame(maxWidth: 420)
            Spacer()
        }
        .padding()
    }
}


