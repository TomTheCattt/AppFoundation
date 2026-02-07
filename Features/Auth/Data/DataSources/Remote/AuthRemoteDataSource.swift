//
//  AuthRemoteDataSource.swift
//  BaseIOSApp
//

import Foundation

protocol AuthRemoteDataSourceProtocol {
    func login(email: String, password: String) async throws -> LoginResponseDTO
    func logout() async throws
}

final class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol
    private let logger: Logger

    init(apiClient: APIClientProtocol, logger: Logger) {
        self.apiClient = apiClient
        self.logger = logger
    }

    func login(email: String, password: String) async throws -> LoginResponseDTO {
        if AppEnvironment.current == .mock {
            return LoginResponseDTO(
                accessToken: "mock_access_\(UUID().uuidString)",
                refreshToken: "mock_refresh_\(UUID().uuidString)",
                expiresIn: 3600
            )
        }
        do {
            return try await apiClient.request(
                AuthEndpoint.login(email: email, password: password).endpoint,
                responseType: LoginResponseDTO.self
            )
        } catch {
            logger.error("AuthRemoteDataSource login failed: \(error)")
            if (error as NSError).code == 401 { throw AuthError.invalidCredentials }
            throw AuthError.from(error)
        }
    }

    func logout() async throws {
        _ = try? await apiClient.request(
            AuthEndpoint.logout.endpoint,
            responseType: EmptyAuthResponse.self
        )
    }
}

private struct EmptyAuthResponse: Decodable {}