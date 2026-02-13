//
//  BuildConfiguration.swift
//  AppFoundation
//
//  Read build-time configuration from .xcconfig / Info.plist.
//

import Foundation

struct BuildConfiguration {
    static var bundleID: String {
        Bundle.main.bundleIdentifier ?? "com.tomthecat.baseIOSApp"
    }

    static var versionNumber: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    static var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    static var apiBaseURL: String {
        Bundle.main.infoDictionary?["API_BASE_URL"] as? String ?? "https://api.example.com"
    }

    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    static var enableLogging: Bool {
        Bundle.main.infoDictionary?["ENABLE_LOGGING"] as? String == "YES"
    }

    static var enableMockServer: Bool {
        if ProcessInfo.processInfo.arguments.contains("ENABLE_MOCK_SERVER") { return true }
        return Bundle.main.infoDictionary?["ENABLE_MOCK_SERVER"] as? String == "YES"
    }

    static var enableDatabaseEncryption: Bool {
        Bundle.main.infoDictionary?["ENABLE_DATABASE_ENCRYPTION"] as? String == "YES"
    }
}
