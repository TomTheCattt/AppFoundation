//
//  Shadows.swift
//  AppFoundation
//
//  Shadow / elevation design tokens.
//

import UIKit

struct DesignSystemShadows {
    struct Shadow {
        let color: UIColor
        let opacity: Float
        let offset: CGSize
        let radius: CGFloat

        func apply(to layer: CALayer) {
            layer.shadowColor = color.cgColor
            layer.shadowOpacity = opacity
            layer.shadowOffset = offset
            layer.shadowRadius = radius
        }
    }

    // MARK: - Elevation Levels

    /// Subtle shadow for flat elements
    static let elevation1 = Shadow(
        color: .black,
        opacity: 0.05,
        offset: CGSize(width: 0, height: 1),
        radius: 2
    )

    /// Standard card shadow
    static let elevation2 = Shadow(
        color: .black,
        opacity: 0.08,
        offset: CGSize(width: 0, height: 2),
        radius: 4
    )

    /// Raised card shadow
    static let elevation3 = Shadow(
        color: .black,
        opacity: 0.12,
        offset: CGSize(width: 0, height: 4),
        radius: 8
    )

    /// Modal/dialog shadow
    static let elevation4 = Shadow(
        color: .black,
        opacity: 0.16,
        offset: CGSize(width: 0, height: 8),
        radius: 16
    )

    /// Maximum elevation
    static let elevation5 = Shadow(
        color: .black,
        opacity: 0.20,
        offset: CGSize(width: 0, height: 12),
        radius: 24
    )
}

// MARK: - UIView Extensions
extension UIView {
    func applyShadow(_ shadow: DesignSystemShadows.Shadow) {
        shadow.apply(to: layer)
    }
}
