//
//  KeychainManagerTests.swift
//  AppFoundationTests
//

import XCTest
@testable import AppFoundation

final class KeychainManagerTests: XCTestCase {
    func test_saveAndLoad() throws {
        let keychain = KeychainManager(service: "test.service")
        let data = Data("test".utf8)
        try keychain.save(data, forKey: "testKey")
        let loaded = try keychain.load(forKey: "testKey")
        XCTAssertEqual(loaded, data)
        try keychain.delete(forKey: "testKey")
    }
}
