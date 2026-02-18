//
//  Spacing.swift
//  AppFoundation
//
//  Spacing system: 8pt grid, padding & margin tokens.
//

import UIKit

struct DesignSystemSpacing {
    /// 4pt - Minimum spacing
    static let xxxs: CGFloat = 4

    /// 8pt - Extra extra small
    static let xxs: CGFloat = 8

    /// 12pt - Extra small
    static let xs: CGFloat = 12

    /// 16pt - Small (Default)
    static let sm: CGFloat = 16

    /// 24pt - Medium
    static let md: CGFloat = 24

    /// 32pt - Large
    static let lg: CGFloat = 32

    /// 40pt - Extra large
    static let xl: CGFloat = 40

    /// 48pt - Extra extra large
    static let xxl: CGFloat = 48

    /// 64pt - Maximum spacing
    static let xxxl: CGFloat = 64

    // MARK: - Semantic Spacing

    /// Padding inside cards/containers
    static let containerPadding: CGFloat = sm

    /// Spacing between sections
    static let sectionSpacing: CGFloat = md

    /// Screen edge margins
    static let screenMargin: CGFloat = sm

    /// Spacing between list items
    static let listItemSpacing: CGFloat = xs
}

// MARK: - UIEdgeInsets Extensions
extension UIEdgeInsets {
    static func all(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }

    static func horizontal(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: value, bottom: 0, right: value)
    }

    static func vertical(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: value, left: 0, bottom: value, right: 0)
    }
}
