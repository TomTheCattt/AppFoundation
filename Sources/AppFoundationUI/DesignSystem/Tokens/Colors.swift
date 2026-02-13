//
//  Colors.swift
//  AppFoundation
//
//  Design tokens - Color palette. Light/Dark mode, semantic naming.
//

import UIKit
import SwiftUI

struct DesignSystemColors {
    // MARK: - Primary Colors
    static let primary = ColorToken(
        light: UIColor(hex: "#007AFF"),
        dark: UIColor(hex: "#0A84FF")
    )

    static let primaryVariant = ColorToken(
        light: UIColor(hex: "#0051D5"),
        dark: UIColor(hex: "#409CFF")
    )

    // MARK: - Semantic Colors
    static let success = ColorToken(
        light: UIColor(hex: "#34C759"),
        dark: UIColor(hex: "#30D158")
    )

    static let warning = ColorToken(
        light: UIColor(hex: "#FF9500"),
        dark: UIColor(hex: "#FF9F0A")
    )

    static let error = ColorToken(
        light: UIColor(hex: "#FF3B30"),
        dark: UIColor(hex: "#FF453A")
    )

    static let info = ColorToken(
        light: UIColor(hex: "#5856D6"),
        dark: UIColor(hex: "#5E5CE6")
    )

    // MARK: - Background Colors
    static let background = ColorToken(
        light: UIColor(hex: "#FFFFFF"),
        dark: UIColor(hex: "#000000")
    )

    static let backgroundSecondary = ColorToken(
        light: UIColor(hex: "#F2F2F7"),
        dark: UIColor(hex: "#1C1C1E")
    )

    static let backgroundTertiary = ColorToken(
        light: UIColor(hex: "#FFFFFF"),
        dark: UIColor(hex: "#2C2C2E")
    )

    // MARK: - Text Colors
    static let textPrimary = ColorToken(
        light: UIColor(hex: "#000000"),
        dark: UIColor(hex: "#FFFFFF")
    )

    static let textSecondary = ColorToken(
        light: UIColor(hex: "#3C3C43", alpha: 0.6),
        dark: UIColor(hex: "#EBEBF5", alpha: 0.6)
    )

    static let textTertiary = ColorToken(
        light: UIColor(hex: "#3C3C43", alpha: 0.3),
        dark: UIColor(hex: "#EBEBF5", alpha: 0.3)
    )

    // MARK: - Border Colors
    static let border = ColorToken(
        light: UIColor(hex: "#3C3C43", alpha: 0.12),
        dark: UIColor(hex: "#545458", alpha: 0.65)
    )

    // MARK: - Helper Methods
    static func color(for colorToken: ColorToken) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark
                    ? colorToken.dark
                    : colorToken.light
            }
        }
        return colorToken.light
    }
}

// MARK: - ColorToken Model
struct ColorToken {
    let light: UIColor
    let dark: UIColor

    var uiColor: UIColor {
        DesignSystemColors.color(for: self)
    }

    var color: Color {
        Color(uiColor)
    }
}

// MARK: - UIColor Extensions
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: alpha
        )
    }
}

// MARK: - SwiftUI Color Extensions
extension Color {
    static let primaryColor = DesignSystemColors.primary.color
    static let successColor = DesignSystemColors.success.color
    static let errorColor = DesignSystemColors.error.color
}
