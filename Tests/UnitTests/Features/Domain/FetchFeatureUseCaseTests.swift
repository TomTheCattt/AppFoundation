//
//  FetchFeatureUseCaseTests.swift
//  BaseIOSAppTests
//

import XCTest
@testable import BaseIOSApp

final class FetchFeatureUseCaseTests: XCTestCase {

    var sut: FetchFeatureUseCase!
    var mockRepository: MockFeatureRepository!
    var mockCache: MockCache!

    override func setUp() {
        super.setUp()
        mockRepository = MockFeatureRepository()
        mockCache = MockCache()
        sut = FetchFeatureUseCase(
            repository: mockRepository,
            logger: Logger.shared,
            cacheManager: mockCache
        )
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        mockCache = nil
        super.tearDown()
    }

    func test_execute_returnsFromCache_whenCacheHasData() async throws {
        let cached = [
            FeatureEntity(id: "c1", title: "Cached", description: "", status: .active, priority: 1, tags: [])
        ]
        try mockCache.set(cached, forKey: "feature_list", expiration: nil)
        mockRepository.fetchAllResult = .success([FeatureEntity(id: "r1", title: "Remote", description: "", status: .active, priority: 0, tags: [])])

        let result = try await sut.execute()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "c1")
        XCTAssertEqual(mockCache.getCallCount, 1)
        XCTAssertEqual(mockRepository.fetchAllCallCount, 0)
    }

    func test_execute_returnsFromRepository_whenCacheEmpty() async throws {
        let entities = [
            FeatureEntity(id: "e1", title: "A", description: "", status: .active, priority: 2, tags: []),
            FeatureEntity(id: "e2", title: "B", description: "", status: .active, priority: 1, tags: [])
        ]
        mockRepository.fetchAllResult = .success(entities)

        let result = try await sut.execute()
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].priority, 2)
        XCTAssertEqual(result[1].priority, 1)
        XCTAssertTrue(mockCache.setCallCount >= 1)
    }

    func test_execute_filtersInactiveAndSortsByPriority() async throws {
        let entities = [
            FeatureEntity(id: "e1", title: "A", description: "", status: .inactive, priority: 10, tags: []),
            FeatureEntity(id: "e2", title: "B", description: "", status: .active, priority: 5, tags: []),
            FeatureEntity(id: "e3", title: "C", description: "", status: .active, priority: 8, tags: [])
        ]
        mockRepository.fetchAllResult = .success(entities)

        let result = try await sut.execute()
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, "e3")
        XCTAssertEqual(result[1].id, "e2")
    }

    func test_execute_throws_whenRepositoryFails() async {
        mockRepository.fetchAllResult = .failure(FeatureError.networkError(NSError(domain: "test", code: -1, userInfo: nil)))
        do {
            _ = try await sut.execute()
            XCTFail("Expected throw")
        } catch {
            XCTAssertTrue(error is FeatureError)
        }
    }

    func test_executeById_returnsEntity() async throws {
        let entity = FeatureEntity(id: "x", title: "X", description: "D", status: .active, priority: 0, tags: [])
        mockRepository.fetchByIdResult = .success(entity)
        let result = try await sut.execute(id: "x")
        XCTAssertEqual(result.id, "x")
    }

    func test_executeById_throws_whenInvalidEntity() async throws {
        let entity = FeatureEntity(id: "x", title: "", description: "D", status: .active, priority: 0, tags: [])
        mockRepository.fetchByIdResult = .success(entity)
        do {
            _ = try await sut.execute(id: "x")
            XCTFail("Expected validation error")
        } catch {
            XCTAssertTrue(error is FeatureError)
        }
    }
}
