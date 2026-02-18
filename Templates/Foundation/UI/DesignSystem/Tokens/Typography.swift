//
//  Typography.swift
//  AppFoundation
//
//  Typography system: text styles, Dynamic Type, line height, letter spacing.
//

import SwiftUI
import UIKit

public struct DesignSystemTypography {
    // MARK: - Font Family
    public enum FontFamily: String {
        case system = "System"
        case sfProDisplay = "SFProDisplay"
        case sfProText = "SFProText"
        case poppins = "Poppins"

        public func font(size: CGFloat, weight: UIFont.Weight) -> UIFont {
            switch self {
            case .system:
                return .systemFont(ofSize: size, weight: weight)
            case .sfProDisplay, .sfProText, .poppins:
                let weightName = weight == .regular ? "Regular" : (weight == .semibold ? "SemiBold" : (weight == .medium ? "Medium" : weight.name))
                return UIFont(name: "\(rawValue)-\(weightName)", size: size)
                    ?? .systemFont(ofSize: size, weight: weight)
            }
        }
    }

    // MARK: - Text Styles - Headers
    public static let title1 = TextStyle(
        font: FontFamily.poppins.font(size: 24, weight: .semibold),
        lineHeight: 32,
        letterSpacing: 0
    )

    public static let title2 = TextStyle(
        font: FontFamily.poppins.font(size: 20, weight: .semibold),
        lineHeight: 28,
        letterSpacing: 0
    )

    public static let title3 = TextStyle(
        font: FontFamily.poppins.font(size: 18, weight: .semibold),
        lineHeight: 24,
        letterSpacing: 0
    )

    // Body
    public static let body1 = TextStyle(
        font: FontFamily.poppins.font(size: 16, weight: .medium),
        lineHeight: 24,
        letterSpacing: 0
    )

    public static let body2 = TextStyle(
        font: FontFamily.poppins.font(size: 16, weight: .regular),
        lineHeight: 24,
        letterSpacing: 0
    )

    public static let body3 = TextStyle(
        font: FontFamily.poppins.font(size: 14, weight: .medium),
        lineHeight: 20,
        letterSpacing: 0
    )

    // Small Text
    public static let caption1 = TextStyle(
        font: FontFamily.poppins.font(size: 12, weight: .semibold),
        lineHeight: 16,
        letterSpacing: 0
    )

    public static let caption2 = TextStyle(
        font: FontFamily.poppins.font(size: 10, weight: .medium),
        lineHeight: 14,
        letterSpacing: 0
    )
    // MARK: - Legacy Aliases
    public static let largeTitle = title1
    public static let body = body2
    public static let bodyBold = body1
    public static let callout = body3
    public static let subheadline = body3
    public static let footnote = caption1
}

// MARK: - TextStyle Model
public struct TextStyle {
    public let font: UIFont
    public let lineHeight: CGFloat
    public let letterSpacing: CGFloat

    public init(font: UIFont, lineHeight: CGFloat, letterSpacing: CGFloat) {
        self.font = font
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
    }

    public func attributes(color: UIColor = .label) -> [NSAttributedString.Key: Any] {
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
