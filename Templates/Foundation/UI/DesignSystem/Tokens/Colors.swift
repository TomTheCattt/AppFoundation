//
//  Colors.swift
//  AppFoundation
//
//  Created by AppFoundation Package.
//

import SwiftUI
import UIKit

public struct DesignSystemColors {
    // MARK: - Primary Colors
    
    /// Primary brand color
    public static var brandPrimary: Color {
        Color(uiColor: brandPrimaryUIColor)
    }
    
    public static var brandPrimaryUIColor: UIColor {
        // Light: Generic Blue, Dark: Lighter Blue for contrast
        .dynamic(light: "#007AFF", dark: "#0A84FF")
    }
    
    /// Secondary brand color
    public static var brandSecondary: Color {
        Color(uiColor: brandSecondaryUIColor)
    }
    
    public static var brandSecondaryUIColor: UIColor {
        // Light: Generic Indigo, Dark: Lighter Indigo
        .dynamic(light: "#5856D6", dark: "#5E5CE6")
    }
    
    // MARK: - Background Colors
    
    /// Main background color (supports dark mode)
    public static var appBackground: Color {
        Color(uiColor: appBackgroundUIColor)
    }
    
    public static var appBackgroundUIColor: UIColor {
        .systemBackground
    }
    
    // MARK: - Color Variants
    
    /// Primary color with 80% opacity
    public static var brandPrimary80: Color {
        brandPrimary.opacity(0.8)
    }
    
    /// White color
    public static var appWhite: Color {
        Color.white
    }
    
    public static var appWhiteUIColor: UIColor {
        .white
    }
    
    /// Black color
    public static var appBlack: Color {
        Color.black
    }
    
    public static var appBlackUIColor: UIColor {
        .black
    }
    
    /// Neutral colors for borders and backgrounds
    public static var neutral40: Color {
        Color(uiColor: UIColor(white: 0.4, alpha: 1.0))
    }
    
    public static var neutral70: Color {
        Color(uiColor: UIColor(white: 0.7, alpha: 1.0))
    }
    
    // MARK: - Semantic Colors
    
    /// Success color (green)
    public static var statusSuccess: Color {
        Color(uiColor: UIColor.systemGreen)
    }
    
    /// Error color (red)
    public static var statusError: Color {
        Color(uiColor: UIColor.systemRed)
    }
    
    /// Warning color (orange)
    public static var statusWarning: Color {
        Color(uiColor: UIColor.systemOrange)
    }
    
    /// Info color (blue)
    public static var statusInfo: Color {
        Color(uiColor: UIColor.systemBlue)
    }
    
    // MARK: - Text Colors
    
    /// Primary text color
    public static var appTextPrimary: Color {
        Color(uiColor: .label)
    }
    
    /// Secondary text color
    public static var appTextSecondary: Color {
        Color(uiColor: .secondaryLabel)
    }
    
    /// Tertiary text color
    public static var appTextTertiary: Color {
        Color(uiColor: .tertiaryLabel)
    }
}
