//
//  Theme.swift
//  Journali
//
//  Created by Nada on 30/05/1448 AH.
//


import SwiftUI

extension Color {
    init(hex: UInt) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}

enum Theme {
    // Colors
    static let primary = Color(hex: 0x7F81FF)
    static let accentText = Color(hex: 0xAF99FD)
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: 0xA39A9A)
    static let card = Color(hex: 0x1C1C1E)
    static let background = Color.black
    static let destructive = Color(hex: 0xFD453C)

    // Fonts (SF Pro is the default system font)
    static let display = Font.system(size: 42, weight: .black)
    static let headingL = Font.system(size: 34, weight: .bold)
    static let headingM = Font.system(size: 24, weight: .bold)
    static let titleCard = Font.system(size: 24, weight: .semibold)
    static let bodyL = Font.system(size: 20, weight: .regular)
    static let bodyM = Font.system(size: 18, weight: .regular)
    static let bodySupporting = Font.system(size: 18, weight: .light)
    static let captionM = Font.system(size: 16, weight: .regular)
    static let captionS = Font.system(size: 14, weight: .regular)
}