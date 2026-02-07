//
//  AppConstants.swift
//  BaseIOSApp
//
//  App-wide constants. Do not change between environments.
//

import Foundation

enum AppConstants {
    enum Network {
        static let timeout: TimeInterval = 30
        static let retryCount: Int = 3
    }

    enum Storage {
        static let databaseName = "BaseIOSApp"
        static let cacheSize: Int = 100 * 1024 * 1024 // 100MB
    }

    enum Security {
        static let keychainService = "com.tomthecat.baseIOSApp"
    }
}
