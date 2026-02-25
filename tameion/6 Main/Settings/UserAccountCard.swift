//
//  UserAccountCard.swift
//  tameion
//
//  Created by Shola Ventures on 1/16/26.
//
import SwiftUI
import PhotosUI

struct UserAccountCard: View {
    private let authService = FirebaseAuthService.shared
    @State private var avatarImage: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?

    var body: some View {
        VStack{
            HStack(spacing: DSSpacing.md) {
                PhotosPicker(selection: $photoPickerItem, matching: .images) {
                    Image(uiImage: avatarImage ?? UIImage(resource: .settingsDefaultAvatar))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)
                        .clipShape(.circle)
                }
                VStack(alignment: .leading) {
                    Text(authService.currentUser?.displayName ?? DSCopy.SettingsView.defaultName)
                        .slimTextStyle(.title)
                    
                    Text(authService.currentUser?.email ?? DSCopy.SettingsView.defaultEmail)
                        .slimTextStyle(.body)
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .padding(.bottom, DSSpacing.sm)
        .onChange(of: photoPickerItem) { _, _ in
            Task {
                if let photoPickerItem,
                   let data = try? await photoPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data:  data) {
                        avatarImage = image
                        // TODO: Save image to profile
                    }
                }
            }
        }
    }
}

