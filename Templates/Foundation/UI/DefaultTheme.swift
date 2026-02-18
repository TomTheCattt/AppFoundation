//
//  DefaultTheme.swift
//  AppFoundationResources
//
//  Created by AppFoundation Package.
//

import UIKit

// MARK: - Default Colors
public struct DefaultColors: ColorThemeProtocol {
    public init() {}
    
    public var primary: UIColor = .systemBlue
    public var secondary: UIColor = .systemTeal
    public var background: UIColor = .systemBackground
    public var surface: UIColor = .secondarySystemBackground
    public var error: UIColor = .systemRed
    public var textPrimary: UIColor = .label
    public var textSecondary: UIColor = .secondaryLabel
    public var textOnPrimary: UIColor = .white
}

// MARK: - Default Fonts
public struct DefaultFonts: FontThemeProtocol {
    public init() {}
    
    public var heading1: UIFont = .systemFont(ofSize: 24, weight: .bold)
    public var heading2: UIFont = .systemFont(ofSize: 20, weight: .semibold)
    public var body: UIFont = .systemFont(ofSize: 16, weight: .regular)
    public var caption: UIFont = .systemFont(ofSize: 12, weight: .regular)
    public var button: UIFont = .systemFont(ofSize: 16, weight: .medium)
}

// MARK: - Default Images
public struct DefaultImages: ImageThemeProtocol {
    public init() {}
    
    public var logo: UIImage? = UIImage(systemName: "app.badge")
    public var emptyState: UIImage? = UIImage(systemName: "tray")
}

// MARK: - Default App Theme
public struct DefaultTheme: AppThemeProtocol {
    public init() {}
    
    public var colors: ColorThemeProtocol = DefaultColors()
    public var fonts: FontThemeProtocol = DefaultFonts()
    public var images: ImageThemeProtocol = DefaultImages()
}
