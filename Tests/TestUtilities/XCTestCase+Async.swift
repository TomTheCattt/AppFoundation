//
//  XCTestCase+Async.swift
//  AppFoundationTests
//

import XCTest

extension XCTestCase {
    func assertThrowsError<T>(
        _ expression: @autoclosure () async throws -> T,
        _ errorHandler: (Error) -> Void
    ) async {
        do {
            _ = try await expression()
            XCTFail("Expected error to be thrown")
        } catch {
            errorHandler(error)
        }
    }
}
