//
//  LogoutUseCase.swift
//  BaseIOSApp
//

import Foundation

protocol LogoutUseCaseProtocol {
    func execute() async throws
}

final class LogoutUseCase: LogoutUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    private let tokenStore: TokenStoreProtocol
    private let logger: Logger

    init(repository: AuthRepositoryProtocol, tokenStore: TokenStoreProtocol, logger: Logger) {
        self.repository = repository
        self.tokenStore = tokenStore
        self.logger = logger
    }

    func execute() async throws {
        try? await repository.logout()
        try tokenStore.clearTokens()
        logger.info("LogoutUseCase: tokens cleared")
    }
}
