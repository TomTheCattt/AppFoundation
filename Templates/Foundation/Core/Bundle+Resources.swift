//
//  Bundle+Resources.swift
//  AppFoundation
//
//  Created by AppFoundation Package.
//

import Foundation

// MARK: - Bundle Extension for Resource Access

extension Bundle {
    /// Returns the bundle containing AppFoundation resources
    /// Works with both CocoaPods and Swift Package Manager
    public static var appFoundationResources: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        // For CocoaPods, resources are in the same bundle as the framework
        return Bundle(for: AppFoundationUIMarker.self)
        #endif
    }
}

// MARK: - Private Marker Class

/// Private marker class used to locate the AppFoundationUI bundle
/// This class exists solely to help Bundle.init(for:) find the correct bundle
private final class AppFoundationUIMarker {}
