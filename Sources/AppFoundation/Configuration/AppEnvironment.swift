//
//  AppEnvironment.swift
//  AppFoundation
//
//  Define app environments and configuration values.
//

import Foundation

public enum AppEnvironment {
    case dev
    case staging
    case production
    case mock

    public static var current: AppEnvironment {
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

    public var baseURL: String {
        BuildConfiguration.apiBaseURL
    }

    public var apiKey: String {
        // In production, load from secure storage
        ""
    }

    public var enableLogging: Bool {
        switch self {
        case .dev, .staging, .mock:
            return true
        case .production:
            return BuildConfiguration.enableLogging
        }
    }

    public var enableEncryption: Bool {
        switch self {
        case .production:
            return BuildConfiguration.enableDatabaseEncryption
        default:
            return false
        }
    }
}
