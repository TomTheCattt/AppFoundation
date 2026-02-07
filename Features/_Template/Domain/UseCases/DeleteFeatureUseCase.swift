//
//  DeleteFeatureUseCase.swift
//  BaseIOSApp
//

import Foundation

protocol DeleteFeatureUseCaseProtocol {
    func execute(id: String) async throws
}

final class DeleteFeatureUseCase: DeleteFeatureUseCaseProtocol {
    private let repository: FeatureRepositoryProtocol
    private let logger: Logger

    init(repository: FeatureRepositoryProtocol, logger: Logger) {
        self.repository = repository
        self.logger = logger
    }

    func execute(id: String) async throws {
        logger.info("DeleteFeatureUseCase - Deleting \(id)")
        try await repository.delete(id: id)
    }
}
