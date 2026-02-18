//
//  BuildConfiguration.swift
//  AppFoundation
//
//  Build-time configuration values.
//

import Foundation

public struct BuildConfiguration {
    public static var bundleID: String {
        Bundle.main.bundleIdentifier ?? ""
    }
    
    public static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    public static var enableMockServer: Bool {
        #if DEBUG
        return false // Set to true to enable mock server in debug builds
        #else
        return false
        #endif
    }
    
    public static var apiBaseURL: String {
        #if DEBUG
        return "https://api-dev.example.com"
        #else
        return "https://api.example.com"
        #endif
    }
    
    public static var enableLogging: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    public static var enableDatabaseEncryption: Bool {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }
}
