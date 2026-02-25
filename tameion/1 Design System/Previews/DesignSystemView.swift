//
//  DesignSystemView.swift
//  tameion
//
//  Created by Shola Ventures on 1/8/26.
//

import SwiftUI

struct DesignSystemView: View {
    @State var exampleTextField: String = "Email Address"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Style Guide").font(DSText.title.font)
                

                VStack(alignment: .leading) {
                    Text("Colors").font(DSText.title.font)
                    HStack {
                        Text("Brand Colors").font(DSText.heading.font)
                        Spacer()
                        ColorSwatch(color: DSColor.navy_blue, label: "Primary")
                        ColorSwatch(color: DSColor.baby_blue, label: "Primary Alt")
                        ColorSwatch(color: DSColor.yellow_gold, label: "Secondary")
                        ColorSwatch(color: DSColor.mustard_gold, label: "Secondary Alt")
                    }.padding()
                    HStack {
                        Text("Secondary Colors").font(DSText.heading.font)
                        Spacer()
                        ColorSwatch(color: DSColor.green_grass, label: "Green")
                        ColorSwatch(color: DSColor.mid_blue, label: "Blue")
                        ColorSwatch(color: DSColor.bright_yellow, label: "Yellow")
                        ColorSwatch(color: DSColor.accent_yellow, label: "Tan")
                    }.padding()
                    HStack {
                        Spacer()
                        ColorSwatch(color: DSColor.terracotta, label: "Terracotta")
                        ColorSwatch(color: DSColor.raspberry_red, label: "Red")
                        ColorSwatch(color: DSColor.lilac_purple, label: "Purple")
                    }.padding()
                    HStack {
                        Text("Neutral Colors").font(DSText.heading.font)
                        Spacer()
                        ColorSwatch(color: DSColor.white, label: "White")
                        ColorSwatch(color: DSColor.off_white_bg, label: "Off White")
                        ColorSwatch(color: DSColor.off_white_txt, label: "Off White")
                        ColorSwatch(color: DSColor.light_gray_border, label: "Light Gray")
                        ColorSwatch(color: DSColor.light_gray_txt, label: "Light Gray")
                    }.padding()
                    HStack {
                        Spacer()
                        ColorSwatch(color: DSColor.gray, label: "Gray")
                        ColorSwatch(color: DSColor.dark_gray_border, label: "Dark Gray")
                        ColorSwatch(color: DSColor.dark_gray_bg, label: "Dark Gray")
                        ColorSwatch(color: DSColor.off_black, label: "Off Black")
                        ColorSwatch(color: DSColor.black, label: "Black")
                    }.padding()
                    

                    Text("Typography").font(DSText.title.font)
                    HStack {
                        Text("Default Entry Style").font(DSText.heading.font)
                        Spacer()
                        Text("This is what entry body styling looks like.")
                            .textStyle(.entryBody)
                    }.padding()
                    HStack {
                        Text("Placeholder Style").font(DSText.heading.font)
                        Spacer()
                        Text("What’s been sitting with you today?")
                            .textStyle(.placeholder)
                    }.padding()
                    HStack {
                        Text("Quote Style").font(DSText.heading.font)
                        Spacer()
                        Text("\"Some thoughts deserve space.\"")
                            .textStyle(.quote)
                    }.padding()
                    HStack {
                        Text("Date Style").font(DSText.heading.font)
                        Spacer()
                        Text("January 9, 2026")
                            .textStyle(.date)
                    }.padding()
                    HStack {
                        Text("Font").font(DSText.heading.font)
                        Spacer()
                        Text("System").font(DSText.body.font)
                    }.padding()


                    Text("Spacing").font(DSText.title.font)
                    HStack {
                        Text("Standard").font(DSText.heading.font)
                        Spacer()
                        Text("\(Int(DSSpacing.sm))px").font(DSText.body.font)
                    }.padding()
                    HStack {
                        Text("Radius").font(DSText.heading.font)
                        Spacer()
                        Text("\(Int(DSRadius.sm))px").font(DSText.body.font)
                    }.padding()


                    Text("Formatter").font(DSText.title.font)
                    HStack {
                        Text("Relative Date").font(DSText.heading.font)
                        Spacer()
                        Text(DSFormatter.relativeDate(date: Date())).font(DSText.body.font)
                    }.padding()
                    HStack {
                        Text("Extended Date").font(DSText.heading.font)
                        Spacer()
                        Text(DSFormatter.longDate(date: Date())).font(DSText.body.font)
                    }.padding()
                    HStack {
                        Text("Date").font(DSText.heading.font)
                        Spacer()
                        Text(DSFormatter.date(date: Date())).font(DSText.body.font)
                    }.padding()
                    HStack {
                        Text("Abbrev. Date").font(DSText.heading.font)
                        Spacer()
                        Text("\(DSFormatter.abbrevDate(date: Date()).0), \(DSFormatter.abbrevDate(date: Date()).1)").font(DSText.body.font)
                    }.padding()
                    HStack {
                        Text("Time").font(DSText.heading.font)
                        Spacer()
                        Text(DSFormatter.time(date: Date())).font(DSText.body.font)
                    }.padding()
                    
                    
                    Text("Button Styles").font(DSText.title.font)
                    HStack {
                        Text("Primary Button").font(DSText.heading.font)
                        Spacer()
                             Button("Getting Started") {
                                 // action
                             }
                             .buttonStyle(PrimaryButtonStyle())
                             .frame(maxWidth: 250)
                    }.padding()
                    HStack {
                        Text("Secondary Button").font(DSText.heading.font)
                        Spacer()
                             Button("Subscribe") {
                                 // action
                             }
                             .buttonStyle(SecondaryButtonStyle())
                             .frame(maxWidth: 250)
                    }.padding()
                    HStack {
                        Text("Cancel Button").font(DSText.heading.font)
                        Spacer()
                             Button("Cancel") {
                                 // action
                             }
                             .buttonStyle(CancelButtonStyle())
                             .frame(maxWidth: 250)
                    }.padding()
                    HStack {
                        Text("Danger Button").font(DSText.heading.font)
                        Spacer()
                             Button(DSCopy.CTA.delete) {
                                 // action
                             }
                             .buttonStyle(DangerButtonStyle())
                             .frame(maxWidth: 250)
                    }.padding()
                    
                    
                }.padding()
                
                    
                Text("Components").font(DSText.title.font)
                VStack(alignment: .leading) {
                    Text("All previews for components are in each specific file.").font(DSText.body.font)
                }.padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

// Reusable color swatch component
struct ColorSwatch: View {
    let color: Color
    let label: String
    
    var body: some View {
        VStack {
            Circle()
                .fill(color)
                .frame(width: 30, height: 30)
            Text(color.toHexString() ?? "Not Found")
            Text(label).font(DSText.caption.font)
        }
    }
}



#Preview {
    DesignSystemView()
}
