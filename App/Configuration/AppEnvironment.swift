//
//  AppEnvironment.swift
//  BaseIOSApp
//
//  Define app environments and configuration values.
//

import Foundation

enum AppEnvironment {
    case dev
    case staging
    case production
    case mock

    static var current: AppEnvironment {
        let bundleID = BuildConfiguration.bundleID.lowercased()
        if bundleID.contains("dev") || BuildConfiguration.isDebug {
            return .dev
        }
        if bundleID.contains("staging") {
            return .staging
        }
        if BuildConfiguration.enableMockServer {
            return .mock
        }
        return .production
    }

    var baseURL: String {
        BuildConfiguration.apiBaseURL
    }

    var apiKey: String {
        // In production, load from secure storage
        ""
    }

    var enableLogging: Bool {
        switch self {
        case .dev, .staging, .mock:
            return true
        case .production:
            return BuildConfiguration.enableLogging
        }
    }

    var enableEncryption: Bool {
        switch self {
        case .production:
            return BuildConfiguration.enableDatabaseEncryption
        default:
            return false
        }
    }
}
