//
//  FooterView.swift
//  tameion
//
//  Created by Shola Ventures on 1/16/26.
//
import SwiftUI

struct FooterView: View {
    @State private var showCanny = false
    
    var body: some View {
        VStack(spacing: DSSpacing.md) {
            Divider()
            
            // Feedback
            HStack {
                Text(DSCopy.SettingsView.provideFeedback)
                    .textStyle(.caption)
                Button(DSCopy.SettingsView.submitFeedback) {
                    showCanny = true
                }
                .padding(.vertical, DSSpacing.md)
                .sheet(isPresented: $showCanny) {
                    CannyView()
                }
                .foregroundStyle(.secondary)
                .textStyle(.link)
            }
            
            // Footer
            Text(DSCopy.Legal.copyright).textStyle(.footnote)
            
        }
        .padding(DSSpacing.lg)
    }
}
