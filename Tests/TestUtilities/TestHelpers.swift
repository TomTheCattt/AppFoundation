//
//  TestHelpers.swift
//  AppFoundationTests
//

import Foundation

enum TestHelpers {
    static var isRunningTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
