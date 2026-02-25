//
//  Card.swift
//  tameion
//
//  Created by Shola Ventures on 1/9/26.
//
import SwiftUI

struct DSCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(DSSpacing.md)
            .background(DSColor.off_white_bg)
            .cornerRadius(DSRadius.md)
            .shadow(color: DSColor.dark_gray_bg, radius: 4, x: 0, y: 2)
    }
}

#Preview {
    DSCard {
        Text("This is a card")
    }

}
