//
//  Colors.swift
//  AppFoundation
//
//  Design tokens - Color palette. Light/Dark mode, semantic naming.
//

import SwiftUI
import UIKit
import AppFoundationResources

struct DesignSystemColors {
    // MARK: - Primary Colors
    static let primary = ColorToken(asset: Asset.primary)
    static let primary80 = ColorToken(asset: Asset.primary80)
    static let primary40 = ColorToken(asset: Asset.primary40)
    static let primary10 = ColorToken(asset: Asset.primary10)

    // MARK: - Neutral Colors
    static let neutral100 = ColorToken(asset: Asset.neutral100)
    static let neutral70 = ColorToken(asset: Asset.neutral70)
    static let neutral60 = ColorToken(asset: Asset.neutral60)
    static let neutral40 = ColorToken(asset: Asset.neutral40)
    static let neutral20 = ColorToken(asset: Asset.neutral20)
    static let white = ColorToken(asset: Asset.white)

    // MARK: - Semantic Colors
    static let success = ColorToken(asset: Asset.semanticSuccess)
    static let warning = ColorToken(asset: Asset.semanticWarning)
    static let error = ColorToken(asset: Asset.semanticError)
    static let info = ColorToken(asset: Asset.semanticInfo)
    static let orange = ColorToken(asset: Asset.semanticOrange)

    // MARK: - Legacy / Background Aliases
    static let background = white
    static let backgroundSecondary = primary10
    static let backgroundTertiary = neutral20

    // MARK: - Legacy / Text Aliases
    static let textPrimary = neutral100
    static let textSecondary = neutral70
    static let textTertiary = neutral60

    // MARK: - Border Colors
    static let border = neutral40

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

    init(light: UIColor, dark: UIColor) {
        self.light = light
        self.dark = dark
    }

    init(asset: ColorAsset) {
        self.light = asset.color
        self.dark = asset.color
    }

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
    
    // New Figma Colors
    static let neutral100 = DesignSystemColors.neutral100.color
    static let neutral70 = DesignSystemColors.neutral70.color
    static let semanticWarning = DesignSystemColors.warning.color
}
