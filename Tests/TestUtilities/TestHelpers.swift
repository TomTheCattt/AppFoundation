//
//  TestHelpers.swift
//  BaseIOSAppTests
//

import Foundation

enum TestHelpers {
    static var isRunningTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
