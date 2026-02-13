//
//  SettingsDemoViewModel.swift
//  AppFoundationExample
//
//  Created by AppFoundation Package.
//

import AppFoundationUI
import AppFoundationResources
import UIKit

class SettingsDemoViewModel: BaseViewModel {
    private let coordinator: DemoAppCoordinator
    
    init(coordinator: DemoAppCoordinator) {
        self.coordinator = coordinator
    }
    
    func switchToDarkTheme() {
        // In real app, define a proper DarkTheme struct
        // For demo, we just modify the DefaultTheme slightly
        var newTheme = DefaultTheme()
        // Mocking a change. Since DefaultTheme uses structs and vars, we can't easily deep modify
        // without a Mutable Protocol or creating a new struct.
        // Assuming DefaultTheme is immutable struct, we create a new one?
        // DefaultTheme has vars.
        
        // Let's just Apply a 'Dark' like colors
        struct DarkModeColors: ColorThemeProtocol {
            var primary = UIColor.orange
            var secondary = UIColor.darkGray
            var background = UIColor.black
            var surface = UIColor.darkGray
            var error = UIColor.red
            var textPrimary = UIColor.white
            var textSecondary = UIColor.lightGray
            var textOnPrimary = UIColor.black
        }
        
        struct DarkTheme: AppThemeProtocol {
            var colors: ColorThemeProtocol = DarkModeColors()
            var fonts: FontThemeProtocol = DefaultFonts()
            var images: ImageThemeProtocol = DefaultImages()
        }
        
        ThemeManager.shared.apply(theme: DarkTheme())
        
        // Notify UI to refresh? BaseViewController checks on ViewDidLoad.
        // Dynamic theme switching usually requires traitCollectionDidChange or Notification.
        // For demo, we might need to reset root VC or just show alert.
    }
    
    func logout() {
        coordinator.logout()
    }
}
