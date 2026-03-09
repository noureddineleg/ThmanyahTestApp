//
//  Typography.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import SwiftUI

enum AppTypography {
    private static func font(size: CGFloat, name: String) -> Font {
        Font.custom(name, size: size)
    }

    // Text styles
    static let largeTitle = font(size: 28, name: "IBMPlexSansArabic-Bold")
    static let title = font(size: 22, name: "IBMPlexSansArabic-Bold")
    static let headline = font(size: 17, name: "IBMPlexSansArabic-SemiBold")
    static let body = font(size: 15, name: "IBMPlexSansArabic-Regular")
    static let caption = font(size: 13, name: "IBMPlexSansArabic-Regular")
    static let small = font(size: 11, name: "IBMPlexSansArabic-Regular")

    // Icon sizes (use for SF Symbols; point size only)
    static let iconLarge = font(size: 48, name: "IBMPlexSansArabic-Regular")
    static let iconMedium = font(size: 32, name: "IBMPlexSansArabic-Regular")
    static let icon = font(size: 20, name: "IBMPlexSansArabic-Regular")
    static let iconSmall = font(size: 12, name: "IBMPlexSansArabic-Regular")
    static let iconTiny = font(size: 10, name: "IBMPlexSansArabic-Regular")
}
