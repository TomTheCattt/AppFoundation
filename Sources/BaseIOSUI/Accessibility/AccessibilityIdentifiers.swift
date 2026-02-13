//
//  AccessibilityIdentifiers.swift
//  BaseIOSApp
//
//  Centralized accessibility identifiers for UI testing and VoiceOver.
//

import Foundation

public enum AccessibilityIdentifier {

    public enum Button {
        public static let primary = "button.primary"
        public static let secondary = "button.secondary"
        public static let close = "button.close"
        public static let submit = "button.submit"
        public static let cancel = "button.cancel"
    }

    public enum TextField {
        public static let email = "textField.email"
        public static let password = "textField.password"
        public static let search = "textField.search"
    }

    public enum Navigation {
        public static let tabBar = "navigation.tabBar"
        public static let navigationBar = "navigation.navigationBar"

        public enum Tab {
            public static let home = "tab.home"
            public static let search = "tab.search"
            public static let profile = "tab.profile"
        }
    }

    public enum Screen {
        public static let home = "screen.home"
        public static let profile = "screen.profile"
        public static let settings = "screen.settings"
    }
}
