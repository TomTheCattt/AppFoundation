//
//  Colors.swift
//  AppFoundation
//
//  Design tokens - Color palette. Light/Dark mode, semantic naming.
//

import SwiftUI
import UIKit
import AppFoundationResources

public struct DesignSystemColors {
    // MARK: - Primary Colors
    public static let primary = ColorToken(asset: Asset.primary)
    public static let primary80 = ColorToken(asset: Asset.primary80)
    public static let primary40 = ColorToken(asset: Asset.primary40)
    public static let primary10 = ColorToken(asset: Asset.primary10)

    // MARK: - Neutral Colors
    public static let neutral100 = ColorToken(asset: Asset.neutral100)
    public static let neutral70 = ColorToken(asset: Asset.neutral70)
    public static let neutral60 = ColorToken(asset: Asset.neutral60)
    public static let neutral40 = ColorToken(asset: Asset.neutral40)
    public static let neutral20 = ColorToken(asset: Asset.neutral20)
    public static let white = ColorToken(asset: Asset.white)

    // MARK: - Semantic Colors
    public static let success = ColorToken(asset: Asset.semanticSuccess)
    public static let warning = ColorToken(asset: Asset.semanticWarning)
    public static let error = ColorToken(asset: Asset.semanticError)
    public static let info = ColorToken(asset: Asset.semanticInfo)
    public static let orange = ColorToken(asset: Asset.semanticOrange)

    // MARK: - Legacy / Background Aliases
    public static let background = white
    public static let backgroundSecondary = primary10
    public static let backgroundTertiary = neutral20

    // MARK: - Legacy / Text Aliases
    public static let textPrimary = neutral100
    public static let textSecondary = neutral70
    public static let textTertiary = neutral60

    // MARK: - Border Colors
    public static let border = neutral40

    // MARK: - Helper Methods
    public static func color(for colorToken: ColorToken) -> UIColor {
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
public struct ColorToken {
    public let light: UIColor
    public let dark: UIColor

    public init(light: UIColor, dark: UIColor) {
        self.light = light
        self.dark = dark
    }

    public init(asset: ColorAsset) {
        self.light = asset.color
        self.dark = asset.color
    }

    public var uiColor: UIColor {
        DesignSystemColors.color(for: self)
    }

    public var color: Color {
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
