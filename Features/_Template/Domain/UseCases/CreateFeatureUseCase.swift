//
//  CreateFeatureUseCase.swift
//  BaseIOSApp
//

import Foundation

protocol CreateFeatureUseCaseProtocol {
    func execute(_ entity: FeatureEntity) async throws -> FeatureEntity
}

final class CreateFeatureUseCase: CreateFeatureUseCaseProtocol {
    private let repository: FeatureRepositoryProtocol
    private let logger: Logger

    init(repository: FeatureRepositoryProtocol, logger: Logger) {
        self.repository = repository
        self.logger = logger
    }

    func execute(_ entity: FeatureEntity) async throws -> FeatureEntity {
        try entity.validate()
        logger.info("CreateFeatureUseCase - Creating")
        return try await repository.create(entity)
    }
}
