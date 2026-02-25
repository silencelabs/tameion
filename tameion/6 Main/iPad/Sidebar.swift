//
//  Sidebar.swift
//  tameion
//
//  Created by Shola Ventures on 1/21/26.
//
import SwiftUI

struct Sidebar: View {
    @Binding var selection: AppSection?

    var body: some View {
        List(selection: $selection) {
            Label(DSCopy.Navigation.ReflectTab.name, systemImage: DSCopy.Navigation.ReflectTab.systemImage)
                .tag(AppSection.journals)

            Label(DSCopy.Navigation.SeekTab.name, systemImage: DSCopy.Navigation.SeekTab.systemImage)
                .tag(AppSection.seek)

            Label(DSCopy.Navigation.Settings.name, systemImage: DSCopy.Navigation.Settings.systemImage)
                .tag(AppSection.settings)
        }
        .navigationTitle("Journal")
    }
}
