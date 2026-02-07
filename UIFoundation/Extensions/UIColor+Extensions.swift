//
//  UIColor+Extensions.swift
//  BaseIOSApp
//
//  UIColor extensions for hex initialization and color manipulation.
//

import UIKit

extension UIColor {
    
    // MARK: - Basic Helpers
    
    /// Initializes a color from a hex string
    /// - Parameter hex: Hex string (e.g., "#FF5733" or "FF5733")
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// Returns a lighter version of the color
    /// - Parameter percentage: Percentage to lighten (0.0 to 1.0)
    /// - Returns: Lighter color
    func lighter(by percentage: CGFloat = 0.2) -> UIColor {
        return adjust(by: abs(percentage))
    }
    
    /// Returns a darker version of the color
    /// - Parameter percentage: Percentage to darken (0.0 to 1.0)
    /// - Returns: Darker color
    func darker(by percentage: CGFloat = 0.2) -> UIColor {
        return adjust(by: -abs(percentage))
    }
    
    // MARK: - Advanced Helpers
    
    /// Returns the complementary color (opposite on color wheel)
    /// - Returns: Complementary color
    var complementary: UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let newHue = fmod(hue + 0.5, 1.0)
        
        return UIColor(hue: newHue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    /// Returns analogous colors (adjacent on color wheel)
    /// - Returns: Array of two analogous colors
    var analogous: [UIColor] {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        let hue1 = fmod(hue + 0.083, 1.0) // +30 degrees
        let hue2 = fmod(hue - 0.083 + 1.0, 1.0) // -30 degrees
        
        return [
            UIColor(hue: hue1, saturation: saturation, brightness: brightness, alpha: alpha),
            UIColor(hue: hue2, saturation: saturation, brightness: brightness, alpha: alpha)
        ]
    }
    
    /// Converts the color to a hex string
    /// - Parameter includeAlpha: Whether to include alpha channel (default: false)
    /// - Returns: Hex string representation
    func toHexString(includeAlpha: Bool = false) -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X",
                         Int(red * 255),
                         Int(green * 255),
                         Int(blue * 255),
                         Int(alpha * 255))
        } else {
            return String(format: "#%02X%02X%02X",
                         Int(red * 255),
                         Int(green * 255),
                         Int(blue * 255))
        }
    }
    
    // MARK: - Private Helpers
    
    /// Adjusts the brightness of the color
    /// - Parameter percentage: Adjustment percentage (-1.0 to 1.0)
    /// - Returns: Adjusted color
    private func adjust(by percentage: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let newBrightness = max(min(brightness + percentage, 1.0), 0.0)
        
        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
    }
}
