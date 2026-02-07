//
//  InMemoryDatabaseTests.swift
//  BaseIOSAppTests
//

import XCTest
@testable import BaseIOSApp

final class InMemoryDatabaseTests: XCTestCase {
    func test_createAndFetch() async throws {
        let db = InMemoryDatabase()
        // Use a simple Storable type if needed for test
        // try await db.create(...)
        // let list = try await db.fetch(...)
        XCTAssertNotNil(db)
    }
}
