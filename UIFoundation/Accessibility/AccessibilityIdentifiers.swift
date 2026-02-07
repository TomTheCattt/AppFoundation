//
//  AccessibilityIdentifiers.swift
//  BaseIOSApp
//
//  Centralized accessibility identifiers for UI testing and VoiceOver.
//

import Foundation

enum AccessibilityIdentifier {

    enum Button {
        static let primary = "button.primary"
        static let secondary = "button.secondary"
        static let close = "button.close"
        static let submit = "button.submit"
        static let cancel = "button.cancel"
    }

    enum TextField {
        static let email = "textField.email"
        static let password = "textField.password"
        static let search = "textField.search"
    }

    enum Navigation {
        static let tabBar = "navigation.tabBar"
        static let navigationBar = "navigation.navigationBar"

        enum Tab {
            static let home = "tab.home"
            static let search = "tab.search"
            static let profile = "tab.profile"
        }
    }

    enum Screen {
        static let home = "screen.home"
        static let profile = "screen.profile"
        static let settings = "screen.settings"
    }
}
