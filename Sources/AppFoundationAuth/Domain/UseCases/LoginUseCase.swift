//
//  LoginUseCase.swift
//  AppFoundation
//

import Foundation
import AppFoundation

protocol LoginUseCaseProtocol {
    func execute(email: String, password: String) async throws
}

final class LoginUseCase: LoginUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    private let tokenStore: TokenStoreProtocol
    private let logger: Logger

    init(repository: AuthRepositoryProtocol, tokenStore: TokenStoreProtocol, logger: Logger) {
        self.repository = repository
        self.tokenStore = tokenStore
        self.logger = logger
    }

    func execute(email: String, password: String) async throws {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            throw AuthError.invalidInput
        }
        let session = try await repository.login(email: trimmedEmail, password: trimmedPassword)
        try tokenStore.setTokens(access: session.accessToken, refresh: session.refreshToken)
        logger.info("LoginUseCase: tokens saved")
    }
}
