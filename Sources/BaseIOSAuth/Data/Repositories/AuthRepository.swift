//
//  AuthRepository.swift
//  BaseIOSApp
//

import Foundation
import BaseIOSCore

final class AuthRepository: AuthRepositoryProtocol {
    private let remoteDataSource: AuthRemoteDataSourceProtocol
    private let logger: Logger

    init(remoteDataSource: AuthRemoteDataSourceProtocol, logger: Logger) {
        self.remoteDataSource = remoteDataSource
        self.logger = logger
    }

    func login(email: String, password: String) async throws -> AuthSession {
        let dto = try await remoteDataSource.login(email: email, password: password)
        return AuthDTOMapper.toSession(dto)
    }

    func register(email: String, password: String) async throws -> AuthSession {
        let dto = try await remoteDataSource.register(email: email, password: password)
        return AuthDTOMapper.toSession(dto)
    }

    func logout() async throws {
        try await remoteDataSource.logout()
    }
}
