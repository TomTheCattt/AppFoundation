//
//  SyncManagerTests.swift
//  AppFoundationTests
//

import XCTest
@testable import AppFoundation

final class SyncManagerTests: XCTestCase {

    var sut: SyncManager!
    var mockNetwork: MockNetworkMonitor!

    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkMonitor()
        sut = SyncManager(
            networkMonitor: mockNetwork,
            logger: Logger.shared
        )
    }

    override func tearDown() {
        sut = nil
        mockNetwork = nil
        super.tearDown()
    }

    func test_whenOnline_storesSyncClosure() async throws {
        var performed = false
        sut.whenOnline(perform: { performed = true })
        mockNetwork.isConnected = true
        try await sut.performSync()
        XCTAssertTrue(performed)
    }

    func test_triggerSync_whenOffline_doesNotRunSync() async {
        var performed = false
        sut.whenOnline(perform: { performed = true })
        mockNetwork.isConnected = false
        sut.triggerSync()
        try? await Task.sleep(nanoseconds: 300_000_000) // 0.3s
        XCTAssertFalse(performed)
    }

    func test_performSync_whenOffline_returnsWithoutRunning() async throws {
        var performed = false
        sut.whenOnline(perform: { performed = true })
        mockNetwork.isConnected = false
        try await sut.performSync()
        XCTAssertFalse(performed)
    }

    func test_performSync_whenOnline_runsClosure() async throws {
        var performed = false
        sut.whenOnline(perform: { performed = true })
        mockNetwork.isConnected = true
        try await sut.performSync()
        XCTAssertTrue(performed)
    }

    func test_performSync_whenOnline_closureThrows_propagates() async {
        sut.whenOnline(perform: { throw NSError(domain: "test", code: -1, userInfo: nil) })
        mockNetwork.isConnected = true
        do {
            try await sut.performSync()
            XCTFail("Expected throw")
        } catch {
            XCTAssertEqual((error as NSError).code, -1)
        }
    }
}
