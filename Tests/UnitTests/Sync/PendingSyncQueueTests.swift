//
//  PendingSyncQueueTests.swift
//  BaseIOSAppTests
//

import XCTest
@testable import BaseIOSApp

final class PendingSyncQueueTests: XCTestCase {

    var sut: UserDefaultsPendingSyncQueue!
    var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: "BaseIOSAppTests.PendingSyncQueue") ?? .standard
        sut = UserDefaultsPendingSyncQueue(defaults: defaults)
        try? sut.removeAll()
    }

    override func tearDown() {
        try? sut.removeAll()
        sut = nil
        defaults = nil
        super.tearDown()
    }

    func test_enqueue_and_count() throws {
        XCTAssertEqual(try sut.count(), 0)
        let item = PendingSyncItem(kind: .create, entityType: "Feature", payload: Data())
        try sut.enqueue(item)
        XCTAssertEqual(try sut.count(), 1)
        try sut.enqueue(PendingSyncItem(kind: .update, entityType: "Feature", payload: Data()))
        XCTAssertEqual(try sut.count(), 2)
    }

    func test_dequeue_returnsInOrder_and_removes() throws {
        let a = PendingSyncItem(kind: .create, entityType: "A", payload: Data("a".utf8))
        let b = PendingSyncItem(kind: .update, entityType: "B", payload: Data("b".utf8))
        try sut.enqueue(a)
        try sut.enqueue(b)
        let batch = try sut.dequeue(limit: 1)
        XCTAssertEqual(batch.count, 1)
        XCTAssertEqual(batch.first?.entityType, "A")
        XCTAssertEqual(try sut.count(), 1)
        let batch2 = try sut.dequeue(limit: 10)
        XCTAssertEqual(batch2.count, 1)
        XCTAssertEqual(batch2.first?.entityType, "B")
        XCTAssertEqual(try sut.count(), 0)
    }

    func test_dequeue_limitRespected() throws {
        for i in 0..<5 {
            try sut.enqueue(PendingSyncItem(kind: .create, entityType: "E\(i)", payload: Data()))
        }
        let batch = try sut.dequeue(limit: 2)
        XCTAssertEqual(batch.count, 2)
        XCTAssertEqual(try sut.count(), 3)
    }

    func test_remove_byIds() throws {
        let id1 = UUID().uuidString
        let id2 = UUID().uuidString
        try sut.enqueue(PendingSyncItem(id: id1, kind: .create, entityType: "X", payload: Data()))
        try sut.enqueue(PendingSyncItem(id: id2, kind: .create, entityType: "Y", payload: Data()))
        try sut.enqueue(PendingSyncItem(kind: .create, entityType: "Z", payload: Data()))
        try sut.remove(ids: [id1])
        XCTAssertEqual(try sut.count(), 2)
        let remaining = try sut.dequeue(limit: 10)
        let types = remaining.map { $0.entityType }.sorted()
        XCTAssertEqual(types, ["Y", "Z"])
    }

    func test_removeAll() throws {
        try sut.enqueue(PendingSyncItem(kind: .create, entityType: "A", payload: Data()))
        try sut.removeAll()
        XCTAssertEqual(try sut.count(), 0)
        let batch = try sut.dequeue(limit: 10)
        XCTAssertTrue(batch.isEmpty)
    }
}
