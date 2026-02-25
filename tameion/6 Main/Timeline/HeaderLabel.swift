//
//  HeaderLabel.swift
//  tameion
//
//  Created by Shola Ventures on 2/5/26.
//
import SwiftUI

struct HeaderLabel: View {

    @State private var showingHelp: [String: Bool] = [:]
    @State var section: EntryActionSection

    var body: some View {

        HStack {
            Text(section.title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)


            Button {
                showingHelp[section.id.uuidString] = true
            } label: {
                Image(systemName: DSCopy.Assets.SFSymbols.helper)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .popover(isPresented: Binding(
                get: { showingHelp[section.id.uuidString] ?? false },
                set: { showingHelp[section.id.uuidString] = $0 }
            )) {
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    Text(section.helper)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .presentationCompactAdaptation(.popover)
            }
        }
    }
}
