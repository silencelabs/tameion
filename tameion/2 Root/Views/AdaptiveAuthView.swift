//
//  AdaptiveAuthView.swift
//  tameion
//
//  Created by Shola Ventures on 1/21/26.
//
import SwiftUI

struct AdaptiveAuthView: View {
    @Environment(\.horizontalSizeClass) private var hSize

    var body: some View {
        if hSize == .regular {
            CenteredContainer {
                AuthView()
            }
        } else {
            AuthView()
        }
    }
}
