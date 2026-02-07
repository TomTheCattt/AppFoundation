//
//  FeatureMocks.swift
//  BaseIOSAppTests
//
//  Mocks for Feature ViewModel, UseCase, and Coordinator tests.
//

import Foundation
import Combine
@testable import BaseIOSApp

// MARK: - Mock Logger (no-op for tests)

final class MockLogger {
    var loggedInfo: [String] = []
    var loggedError: [String] = []
}

extension MockLogger {
    func info(_ message: String) { loggedInfo.append(message) }
    func error(_ message: String) { loggedError.append(message) }
    func warning(_ message: String) {}
    func debug(_ message: String) {}
}

// MARK: - Mock FetchFeatureUseCase

final class MockFetchFeatureUseCase: FetchFeatureUseCaseProtocol {
    var executeResult: Result<[FeatureEntity], Error> = .success([])
    var executeByIdResult: Result<FeatureEntity, Error> = .failure(FeatureError.notFound(id: ""))
    var executeCallCount = 0
    var executeByIdCallCount = 0

    func execute() async throws -> [FeatureEntity] {
        executeCallCount += 1
        switch executeResult {
        case .success(let list): return list
        case .failure(let error): throw error
        }
    }

    func execute(id: String) async throws -> FeatureEntity {
        executeByIdCallCount += 1
        switch executeByIdResult {
        case .success(let entity): return entity
        case .failure(let error): throw error
        }
    }
}

// MARK: - Mock CreateFeatureUseCase

final class MockCreateFeatureUseCase: CreateFeatureUseCaseProtocol {
    var executeResult: Result<FeatureEntity, Error> = .failure(FeatureError.unknown(NSError(domain: "test", code: -1, userInfo: nil)))
    func execute(_ entity: FeatureEntity) async throws -> FeatureEntity {
        switch executeResult {
        case .success(let e): return e
        case .failure(let err): throw err
        }
    }
}

// MARK: - Mock UpdateFeatureUseCase

final class MockUpdateFeatureUseCase: UpdateFeatureUseCaseProtocol {
    var executeResult: Result<FeatureEntity, Error> = .failure(FeatureError.notFound(id: ""))
    func execute(_ entity: FeatureEntity) async throws -> FeatureEntity {
        switch executeResult {
        case .success(let e): return e
        case .failure(let err): throw err
        }
    }
}

// MARK: - Mock DeleteFeatureUseCase

final class MockDeleteFeatureUseCase: DeleteFeatureUseCaseProtocol {
    var executeError: Error?
    var executeCallCount = 0
    func execute(id: String) async throws {
        executeCallCount += 1
        if let e = executeError { throw e }
    }
}

// MARK: - Mock FeatureCoordinator

final class MockFeatureCoordinator: FeatureCoordinatorProtocol {
    var showDetailCalled = false
    var showDetailItem: FeatureEntity?
    var showCreateScreenCalled = false
    var showEditCalled = false
    var showEditItem: FeatureEntity?

    func showDetail(for item: FeatureEntity) {
        showDetailCalled = true
        showDetailItem = item
    }

    func showCreateScreen() {
        showCreateScreenCalled = true
    }

    func showEdit(for item: FeatureEntity) {
        showEditCalled = true
        showEditItem = item
    }
}

// MARK: - Mock FeatureRepository (for UseCase tests)

final class MockFeatureRepository: FeatureRepositoryProtocol {
    var fetchAllResult: Result<[FeatureEntity], Error> = .success([])
    var fetchByIdResult: Result<FeatureEntity, Error> = .failure(FeatureError.notFound(id: ""))
    var fetchAllCallCount = 0

    func fetchAll() async throws -> [FeatureEntity] {
        fetchAllCallCount += 1
        switch fetchAllResult {
        case .success(let list): return list
        case .failure(let e): throw e
        }
    }

    func fetch(id: String) async throws -> FeatureEntity {
        switch fetchByIdResult {
        case .success(let e): return e
        case .failure(let err): throw err
        }
    }

    func create(_ entity: FeatureEntity) async throws -> FeatureEntity { entity }
    func update(_ entity: FeatureEntity) async throws -> FeatureEntity { entity }
    func delete(id: String) async throws {}
    func deleteAll() async throws {}
    func search(query: String) async throws -> [FeatureEntity] { [] }
}

// MARK: - Mock Cache (for UseCase tests)

final class MockCache: CacheProtocol {
    var storage: [String: (Data, TimeInterval?)] = [:]
    var getCallCount = 0
    var setCallCount = 0

    func set<T: Encodable>(_ value: T, forKey key: String, expiration: TimeInterval? = nil) throws {
        setCallCount += 1
        let data = try JSONEncoder().encode(value)
        storage[key] = (data, expiration)
    }

    func get<T: Decodable>(forKey key: String) throws -> T? {
        getCallCount += 1
        guard let (data, _) = storage[key] else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func remove(forKey key: String) throws { storage.removeValue(forKey: key) }
    func removeAll() throws { storage.removeAll() }
    func exists(forKey key: String) -> Bool { storage[key] != nil }
}
