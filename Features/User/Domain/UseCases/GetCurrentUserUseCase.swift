//
//  GetCurrentUserUseCase.swift
//  BaseIOSApp
//

import Foundation

protocol GetCurrentUserUseCaseProtocol {
    func execute() async throws -> UserEntity
}

final class GetCurrentUserUseCase: GetCurrentUserUseCaseProtocol {
    private let repository: UserRepositoryProtocol
    private let logger: Logger

    init(repository: UserRepositoryProtocol, logger: Logger) {
        self.repository = repository
        self.logger = logger
    }

    func execute() async throws -> UserEntity {
        logger.info("GetCurrentUserUseCase - Fetching")
        return try await repository.getCurrentUser()
    }
}
