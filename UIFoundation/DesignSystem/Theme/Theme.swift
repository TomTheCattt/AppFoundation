//
//  Theme.swift
//  BaseIOSApp
//
//  Theme protocol and Light/Dark theme implementations.
//

import UIKit

protocol Theme {
    var primaryColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var textPrimaryColor: UIColor { get }
    var textSecondaryColor: UIColor { get }
    var errorColor: UIColor { get }
    var successColor: UIColor { get }

    var headingFont: UIFont { get }
    var bodyFont: UIFont { get }

    var statusBarStyle: UIStatusBarStyle { get }
}

// MARK: - Light Theme
class LightTheme: Theme {
    var primaryColor: UIColor { DesignSystemColors.primary.light }
    var backgroundColor: UIColor { DesignSystemColors.background.light }
    var textPrimaryColor: UIColor { DesignSystemColors.textPrimary.light }
    var textSecondaryColor: UIColor { DesignSystemColors.textSecondary.light }
    var errorColor: UIColor { DesignSystemColors.error.light }
    var successColor: UIColor { DesignSystemColors.success.light }

    var headingFont: UIFont { DesignSystemTypography.title1.font }
    var bodyFont: UIFont { DesignSystemTypography.body.font }

    var statusBarStyle: UIStatusBarStyle { .darkContent }
}

// MARK: - Dark Theme
class DarkTheme: Theme {
    var primaryColor: UIColor { DesignSystemColors.primary.dark }
    var backgroundColor: UIColor { DesignSystemColors.background.dark }
    var textPrimaryColor: UIColor { DesignSystemColors.textPrimary.dark }
    var textSecondaryColor: UIColor { DesignSystemColors.textSecondary.dark }
    var errorColor: UIColor { DesignSystemColors.error.dark }
    var successColor: UIColor { DesignSystemColors.success.dark }

    var headingFont: UIFont { DesignSystemTypography.title1.font }
    var bodyFont: UIFont { DesignSystemTypography.body.font }

    var statusBarStyle: UIStatusBarStyle { .lightContent }
}
