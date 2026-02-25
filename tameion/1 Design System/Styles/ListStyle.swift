//
//  ListStyle.swift
//  tameion
//
//  Created by Shola Ventures on 1/11/26.
//
import SwiftUI

//Options:
//archive
//search
//compact
enum DSListStyle {
    case journal
    case plain
    case grouped
}

struct DSListStyleModifier: ViewModifier {
    let style: DSListStyle

    func body(content: Content) -> some View {
        switch style {
        case .journal:
            content
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .environment(\.defaultMinListRowHeight, 0)
                .padding(.horizontal, DSSpacing.md)

        case .plain:
            content
                .listStyle(.plain)

        case .grouped:
            content
                .listStyle(.insetGrouped)
        }
    }
}

extension View {
    func listStyled(_ style: DSListStyle) -> some View {
        modifier(DSListStyleModifier(style: style))
    }
}

enum DSListRowStyle {
    case journal
}

struct DSListRowStyleModifier: ViewModifier {
    let style: DSListRowStyle

    func body(content: Content) -> some View {
        switch style {
        case .journal:
            content
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
                .padding(.vertical, DSSpacing.xs)
        }
    }
}

extension View {
    func dsListRowStyle(_ style: DSListRowStyle) -> some View {
        modifier(DSListRowStyleModifier(style: style))
    }
}



//#Preview {
//    List(entries) { entry in
//        DSEntryCard(
//            title: entry.title,
//            preview: entry.body,
//            date: entry.date
//        )
//        .listRowSeparator(.hidden)
//        .listRowInsets(.init())
//        .padding(.vertical, DSSpacing.xs)
//    }
//    .dsListStyle(.journal)
//
//    List(entries) { entry in
//        DSEntryCard(...)
//            .dsListRowStyle(.journal)
//    }
//    .dsListStyle(.journal)
//
//}

