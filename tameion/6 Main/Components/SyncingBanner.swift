//
//  SyncingBanner.swift
//  tameion
//
//  Created by Shola Ventures on 2/6/26.
//
import SwiftUI

struct SyncingBanner: View {

    var body: some View {
        HStack(spacing: DSSpacing.sm) {
            ProgressView()
                .tint(.white)
                .scaleEffect(0.8)
            Text("Syncing...")
                .font(.caption)
        }
        .foregroundColor(.black)
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.sm)
        .background(.ultraThinMaterial)
        .cornerRadius(DSSpacing.lg)
        .padding(.bottom, DSSpacing.md)
        .transition(.move(edge: .bottom)) //.combined(with: .opacity))
    }
}

