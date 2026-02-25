//
//  Button.swift
//  tameion
//
//  Created by Shola Ventures on 1/9/26.
//
import SwiftUI

enum DSButtonRole {
    case primary
    case secondary
    case cancel
    case danger
    case external
}

struct AnyButtonStyle: ButtonStyle {
    private let makeBodyClosure: (Configuration) -> AnyView

    init<S: ButtonStyle>(_ style: S) {
        self.makeBodyClosure = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        makeBodyClosure(configuration)
    }
}

struct DSButton: View {
    let image: String
    let title: String
    let role: DSButtonRole
    let isLoading: Bool
    let isEnabled: Bool
    let action: () -> Void

    init(
        _ title: String,
        image: String? = nil,
        role: DSButtonRole = .primary,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.image = image ?? ""
        self.role = role
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button {
            guard !isLoading else { return }
            DSHaptic.button(role)
            action()
        } label: {
            ZStack {
                if !image.isEmpty {
                    HStack {
                        Image(image)
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(title)
                            .buttonTextStyle(.entryBody)
                            .opacity(isLoading ? 0 : 1)
                    }
                } else {
                    Text(title)
                        .buttonTextStyle(.entryBody)
                        .opacity(isLoading ? 0 : 1)
                }
                

                if isLoading {
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: spinnerColor)
                        )
                }
            }
        }
        .buttonStyle(resolvedButtonStyle)
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1 : 0.4)
    }

    private var resolvedButtonStyle: AnyButtonStyle {
        switch role {
        case .primary:
            return AnyButtonStyle(PrimaryButtonStyle())
        case .secondary:
            return AnyButtonStyle(SecondaryButtonStyle())
        case .cancel:
            return AnyButtonStyle(CancelButtonStyle())
        case .danger:
            return AnyButtonStyle(DangerButtonStyle())
        case .external:
            return AnyButtonStyle(ExternalButtonStyle())
        }
    }

    private var spinnerColor: Color {
        switch role {
        case .primary:
            return DSColor.secondary
        case .secondary, .cancel:
            return DSColor.primary
        case .danger:
            return DSColor.off_white_txt
        case .external:
            return DSColor.light_gray_border
        }
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading) {
            Text("Buttons").font(DSText.title.font)
            HStack {
                Text("Primary Button").font(DSText.heading.font)
                Spacer()
                DSButton(DSCopy.CTA.save, role: .primary) {
                    // save action
                }
                .containerRelativeFrame(.horizontal, count: 10, span: 5, spacing: DSSpacing.md)
            }.padding()
            HStack {
                Text("Secondary Button").font(DSText.heading.font)
                Spacer()
                DSButton(DSCopy.CTA.continued, role: .secondary) {
                    // save action
                }
                .containerRelativeFrame(.horizontal, count: 10, span: 5, spacing: DSSpacing.md)
            }.padding()
            HStack {
                Text("Google Button").font(DSText.heading.font)
                Spacer()
                DSButton(DSCopy.Auth.SignIn.withGoogle, image: DSCopy.Assets.Logos.google, role: .external) {
                    // save action
                }
                .containerRelativeFrame(.horizontal, count: 10, span: 5, spacing: DSSpacing.md)
            }.padding()
            HStack {
                Text("Cancel Button").font(DSText.heading.font)
                Spacer()
                DSButton(DSCopy.CTA.cancel, role: .cancel) {
                    // save action
                }
                .containerRelativeFrame(.horizontal, count: 10, span: 5, spacing: DSSpacing.md)
            }.padding()
            HStack {
                Text("Danger Button").font(DSText.heading.font)
                Spacer()
                DSButton(DSCopy.CTA.delete, role: .danger) {
                    // save action
                }
                .containerRelativeFrame(.horizontal, count: 10, span: 5, spacing: DSSpacing.md)
            }.padding()
        }.padding()
    }
}
