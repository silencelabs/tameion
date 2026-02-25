//
//  AdaptiveMainView.swift
//  tameion
//
//  Created by Shola Ventures on 1/21/26.
//
import SwiftUI

struct AdaptiveMainView: View {
    @Environment(\.horizontalSizeClass) private var hSize

    var body: some View {
        if hSize == .regular {
            SplitMainView()
        } else {
            MainView()
        }
    }
}
