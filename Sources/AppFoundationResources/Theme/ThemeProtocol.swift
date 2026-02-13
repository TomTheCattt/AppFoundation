//
//  ThemeProtocol.swift
//  AppFoundationResources
//
//  Created by AppFoundation Package.
//

import UIKit

// MARK: - Color Theme
public protocol ColorThemeProtocol {
    var primary: UIColor { get }
    var secondary: UIColor { get }
    var background: UIColor { get }
    var surface: UIColor { get }
    var error: UIColor { get }
    var textPrimary: UIColor { get }
    var textSecondary: UIColor { get }
    var textOnPrimary: UIColor { get }
}

// MARK: - Font Theme
public protocol FontThemeProtocol {
    var heading1: UIFont { get }
    var heading2: UIFont { get }
    var body: UIFont { get }
    var caption: UIFont { get }
    var button: UIFont { get }
}

// MARK: - Image Theme (Optional)
public protocol ImageThemeProtocol {
    var logo: UIImage? { get }
    var emptyState: UIImage? { get }
}

// MARK: - App Theme
public protocol AppThemeProtocol {
    var colors: ColorThemeProtocol { get }
    var fonts: FontThemeProtocol { get }
    var images: ImageThemeProtocol { get }
}
