//
//  ThemeManager.swift
//  BaseIOSResources
//
//  Created by BaseIOSApp Package.
//

import Foundation

public final class ThemeManager {
    public static let shared = ThemeManager()
    
    private var currentTheme: AppThemeProtocol = DefaultTheme()
    
    private init() {}
    
    public func apply(theme: AppThemeProtocol) {
        self.currentTheme = theme
    }
    
    public var theme: AppThemeProtocol {
        return currentTheme
    }
    
    // Convenient Accessors
    public var colors: ColorThemeProtocol { theme.colors }
    public var fonts: FontThemeProtocol { theme.fonts }
    public var images: ImageThemeProtocol { theme.images }
}
