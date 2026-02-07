//
//  XCTestCase+Extensions.swift
//  BaseIOSAppTests
//

import XCTest

extension XCTestCase {
    func wait(timeout: TimeInterval = 1.0) async throws {
        try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
    }
}
