//
//  SplitMainView.swift
//  tameion
//
//  Created by Shola Ventures on 1/21/26.
//
import SwiftUI

enum AppSection: Hashable {
    case journals
    case seek
    case settings
}

struct SplitMainView: View {
    @State private var selection: AppSection? = .journals

    var body: some View {
        NavigationSplitView {
            Sidebar(selection: $selection)
        } detail: {
            Detail(for: selection)
        }
    }
}

