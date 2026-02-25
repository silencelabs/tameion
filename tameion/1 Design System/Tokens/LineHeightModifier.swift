//
//  LineHeightModifier.swift
//  tameion
//
//  Created by Shola Ventures on 1/9/26.
//
import SwiftUI

struct LineHeightModifier: ViewModifier {
    let lineHeight: CGFloat
    let fontSize: CGFloat

    func body(content: Content) -> some View {
        content
            .lineSpacing(lineHeight - fontSize)
            .padding(.vertical, (lineHeight - fontSize) / 2)
    }
}

