//
//  UIColor+Hex.swift
//  AppFoundation
//
//  Created by AppFoundation Package.
//

import UIKit

extension UIColor {
    /// Convenience initializer to create UIColor from hex string
    /// - Parameters:
    ///   - hex: Hex string (e.g., "#FF0000" or "FF0000")
    ///   - alpha: Alpha value (0.0 to 1.0)
    public convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// Create a dynamic color that automatically switches between light and dark modes
    /// - Parameters:
    ///   - lightHex: Hex string for light mode
    ///   - darkHex: Hex string for dark mode
    ///   - alpha: Alpha transparency
    /// - Returns: A dynamic UIColor object
    public static func dynamic(light lightHex: String, dark darkHex: String, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(hex: darkHex, alpha: alpha)
            } else {
                return UIColor(hex: lightHex, alpha: alpha)
            }
        }
    }
}
