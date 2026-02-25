//
//  StaticCard.swift
//  tameion
//
//  Created by Shola Ventures on 1/11/26.
//
import SwiftUI

struct DSStaticCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DSRadius.md)
                .fill(DSColor.surface)
                .shadow(
                    color: DSColor.dark_gray_border,
                    radius: 4,
                    x: 0,
                    y: 2
                )
            
            content
        }
    }
}

#Preview {
    DSStaticCard {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text("What’s been sitting with you today?")
                .textStyle(.sectionHeader)

            Text("Psalm 46:10")
                .textStyle(.caption)
                .foregroundColor(DSColor.textSecondary)
        }
    }

}
