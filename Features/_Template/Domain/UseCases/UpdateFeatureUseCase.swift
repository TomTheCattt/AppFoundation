//
//  UpdateFeatureUseCase.swift
//  BaseIOSApp
//

import Foundation

protocol UpdateFeatureUseCaseProtocol {
    func execute(_ entity: FeatureEntity) async throws -> FeatureEntity
}

final class UpdateFeatureUseCase: UpdateFeatureUseCaseProtocol {
    private let repository: FeatureRepositoryProtocol
    private let logger: Logger

    init(repository: FeatureRepositoryProtocol, logger: Logger) {
        self.repository = repository
        self.logger = logger
    }

    func execute(_ entity: FeatureEntity) async throws -> FeatureEntity {
        try entity.validate()
        logger.info("UpdateFeatureUseCase - Updating \(entity.id)")
        return try await repository.update(entity)
    }
}
