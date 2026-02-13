//
//  Typography.swift
//  AppFoundation
//
//  Typography system: text styles, Dynamic Type, line height, letter spacing.
//

import UIKit
import SwiftUI

struct DesignSystemTypography {
    // MARK: - Font Family
    enum FontFamily: String {
        case system = "System"
        case sfProDisplay = "SFProDisplay"
        case sfProText = "SFProText"

        func font(size: CGFloat, weight: UIFont.Weight) -> UIFont {
            switch self {
            case .system:
                return .systemFont(ofSize: size, weight: weight)
            case .sfProDisplay, .sfProText:
                return UIFont(name: "\(rawValue)-\(weight.name)", size: size)
                    ?? .systemFont(ofSize: size, weight: weight)
            }
        }
    }

    // MARK: - Text Styles - Headers
    static let largeTitle = TextStyle(
        font: FontFamily.system.font(size: 34, weight: .bold),
        lineHeight: 41,
        letterSpacing: 0.37
    )

    static let title1 = TextStyle(
        font: FontFamily.system.font(size: 28, weight: .bold),
        lineHeight: 34,
        letterSpacing: 0.36
    )

    static let title2 = TextStyle(
        font: FontFamily.system.font(size: 22, weight: .bold),
        lineHeight: 28,
        letterSpacing: 0.35
    )

    static let title3 = TextStyle(
        font: FontFamily.system.font(size: 20, weight: .semibold),
        lineHeight: 25,
        letterSpacing: 0.38
    )

    // Body
    static let body = TextStyle(
        font: FontFamily.system.font(size: 17, weight: .regular),
        lineHeight: 22,
        letterSpacing: -0.41
    )

    static let bodyBold = TextStyle(
        font: FontFamily.system.font(size: 17, weight: .semibold),
        lineHeight: 22,
        letterSpacing: -0.41
    )

    static let callout = TextStyle(
        font: FontFamily.system.font(size: 16, weight: .regular),
        lineHeight: 21,
        letterSpacing: -0.32
    )

    // Small Text
    static let subheadline = TextStyle(
        font: FontFamily.system.font(size: 15, weight: .regular),
        lineHeight: 20,
        letterSpacing: -0.24
    )

    static let footnote = TextStyle(
        font: FontFamily.system.font(size: 13, weight: .regular),
        lineHeight: 18,
        letterSpacing: -0.08
    )

    static let caption1 = TextStyle(
        font: FontFamily.system.font(size: 12, weight: .regular),
        lineHeight: 16,
        letterSpacing: 0
    )

    static let caption2 = TextStyle(
        font: FontFamily.system.font(size: 11, weight: .regular),
        lineHeight: 13,
        letterSpacing: 0.07
    )
}

// MARK: - TextStyle Model
struct TextStyle {
    let font: UIFont
    let lineHeight: CGFloat
    let letterSpacing: CGFloat

    func attributes(color: UIColor = DesignSystemColors.textPrimary.uiColor) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        return [
            .font: font,
            .foregroundColor: color,
            .kern: letterSpacing,
            .paragraphStyle: paragraphStyle
        ]
    }
}

// MARK: - UIFont.Weight Extension
extension UIFont.Weight {
    var name: String {
        switch self {
        case .ultraLight: return "UltraLight"
        case .thin: return "Thin"
        case .light: return "Light"
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .semibold: return "Semibold"
        case .bold: return "Bold"
        case .heavy: return "Heavy"
        case .black: return "Black"
        default: return "Regular"
        }
    }
}

// MARK: - SwiftUI Font Extensions
extension Font {
    static let largeTitle = Font(DesignSystemTypography.largeTitle.font as CTFont)
    static let title1 = Font(DesignSystemTypography.title1.font as CTFont)
    static let title2 = Font(DesignSystemTypography.title2.font as CTFont)
    static let bodyText = Font(DesignSystemTypography.body.font as CTFont)
}
