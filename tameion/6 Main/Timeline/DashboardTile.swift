//
//  DashboardTile.swift
//  tameion
//
//  Created by Shola Ventures on 2/4/26.
//
import SwiftUI

struct DashboardTile: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: DSSpacing.xs) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(label)
                .font(.caption)
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DSSpacing.md)
        .background(color.opacity(0.1))
        .cornerRadius(DSSpacing.md)
    }
}
