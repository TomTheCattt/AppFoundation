//
//  UserRemoteDataSource.swift
//  BaseIOSApp
//

import Foundation

protocol UserRemoteDataSourceProtocol {
    func getCurrentUser() async throws -> UserDTO
}

final class UserRemoteDataSource: UserRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol
    private let logger: Logger

    init(apiClient: APIClientProtocol, logger: Logger) {
        self.apiClient = apiClient
        self.logger = logger
    }

    func getCurrentUser() async throws -> UserDTO {
        if AppEnvironment.current == .mock {
            return UserDTO(
                id: "mock-user-1",
                email: "user@example.com",
                name: "Mock User",
                avatarURL: nil
            )
        }
        do {
            return try await apiClient.request(
                UserEndpoint.me.endpoint,
                responseType: UserDTO.self
            )
        } catch {
            logger.error("UserRemoteDataSource getCurrentUser failed: \(error)")
            throw UserError.from(error)
        }
    }
}
