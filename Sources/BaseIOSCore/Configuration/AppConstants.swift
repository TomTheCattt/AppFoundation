//
//  AppConstants.swift
//  BaseIOSApp
//
//  App-wide constants. Do not change between environments.
//

import Foundation

public enum AppConstants {
    public enum Network {
        public static let timeout: TimeInterval = 30
        public static let retryCount: Int = 3
    }

    public enum Storage {
        public static let databaseName = "BaseIOSApp"
        public static let cacheSize: Int = 100 * 1024 * 1024 // 100MB
    }

    public enum Security {
        public static let keychainService = "com.tomthecat.baseIOSApp"
    }
}
