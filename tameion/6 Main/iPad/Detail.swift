//
//  Detail.swift
//  tameion
//
//  Created by Shola Ventures on 1/21/26.
//
import SwiftUI

@ViewBuilder
func Detail(for section: AppSection?) -> some View {
    switch section {
    case .journals:
        ReflectView()
    case .seek:
        SeekView()
    case .settings:
        SettingsView()
    case .none:
        Text("Select something")
    }
}
