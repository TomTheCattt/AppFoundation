//
//  ThemeManager.swift
//  BaseIOSApp
//
//  Manages current theme, switching, persistence, and notifies observers.
//

import UIKit
import Combine

final class ThemeManager: ObservableObject {
    // MARK: - Singleton
    static let shared = ThemeManager()
    private init() {
        loadSavedTheme()
    }

    // MARK: - Properties
    @Published private(set) var currentTheme: Theme = LightTheme()

    private let themeKey = "app.theme"

    enum ThemeType: String {
        case light
        case dark
        case system

        var theme: Theme {
            switch self {
            case .light: return LightTheme()
            case .dark: return DarkTheme()
            case .system: return Self.systemTheme()
            }
        }

        static func systemTheme() -> Theme {
            if #available(iOS 13.0, *) {
                let style = UITraitCollection.current.userInterfaceStyle
                return style == .dark ? DarkTheme() : LightTheme()
            }
            return LightTheme()
        }
    }

    // MARK: - Public Methods

    func apply(_ themeType: ThemeType) {
        currentTheme = themeType.theme
        saveTheme(themeType)
        applyThemeToApp()
    }

    func systemThemeDidChange() {
        if getCurrentThemeType() == .system {
            currentTheme = ThemeType.systemTheme()
            applyThemeToApp()
        }
    }

    // MARK: - Private Methods

    private func loadSavedTheme() {
        let themeType = getCurrentThemeType()
        currentTheme = themeType.theme
    }

    private func getCurrentThemeType() -> ThemeType {
        guard let rawValue = UserDefaults.standard.string(forKey: themeKey),
              let themeType = ThemeType(rawValue: rawValue) else {
            return .system
        }
        return themeType
    }

    private func saveTheme(_ themeType: ThemeType) {
        UserDefaults.standard.set(themeType.rawValue, forKey: themeKey)
    }

    private func applyThemeToApp() {
        let style = getCurrentInterfaceStyle()
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                guard let windowScene = scene as? UIWindowScene else { continue }
                for window in windowScene.windows {
                    window.overrideUserInterfaceStyle = style
                }
            }
        }

        NotificationCenter.default.post(
            name: .themeDidChange,
            object: nil
        )
    }

    private func getCurrentInterfaceStyle() -> UIUserInterfaceStyle {
        switch getCurrentThemeType() {
        case .light: return .light
        case .dark: return .dark
        case .system: return .unspecified
        }
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let themeDidChange = Notification.Name("themeDidChange")
}
