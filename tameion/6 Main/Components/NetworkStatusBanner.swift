//
//  NetworkStatusBanner.swift
//  tameion
//
//  Created by Shola Ventures on 2/6/26.
//
import SwiftUI

struct NetworkStatusBanner: View {

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "wifi.slash")
                .font(.caption)
            Text("Offline")
                .font(.caption)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.orange)
        .cornerRadius(20)
        .padding(.bottom, 16)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
