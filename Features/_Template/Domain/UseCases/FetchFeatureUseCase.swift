//
//  FetchFeatureUseCase.swift
//  BaseIOSApp
//

import Foundation

protocol FetchFeatureUseCaseProtocol {
    func execute() async throws -> [FeatureEntity]
    func execute(id: String) async throws -> FeatureEntity
}

final class FetchFeatureUseCase: FetchFeatureUseCaseProtocol {
    private let repository: FeatureRepositoryProtocol
    private let logger: Logger
    private let cacheManager: CacheProtocol

    init(
        repository: FeatureRepositoryProtocol,
        logger: Logger,
        cacheManager: CacheProtocol
    ) {
        self.repository = repository
        self.logger = logger
        self.cacheManager = cacheManager
    }

    func execute() async throws -> [FeatureEntity] {
        logger.info("FetchFeatureUseCase - Fetching all")

        if let cached: [FeatureEntity] = try cacheManager.get(forKey: "feature_list") {
            return cached
        }

        do {
            let items = try await repository.fetchAll()
            var validatedItems: [FeatureEntity] = []
            for item in items {
                try item.validate()
                validatedItems.append(item)
            }
            let activeItems = validatedItems.filter { $0.isActive }
            let sortedItems = activeItems.sorted { $0.priority > $1.priority }
            try cacheManager.set(sortedItems, forKey: "feature_list", expiration: 300)
            return sortedItems
        } catch {
            logger.error("Failed to fetch: \(error)")
            throw FeatureError.from(error)
        }
    }

    func execute(id: String) async throws -> FeatureEntity {
        logger.info("FetchFeatureUseCase - Fetching \(id)")
        let item = try await repository.fetch(id: id)
        try item.validate()
        return item
    }
}
