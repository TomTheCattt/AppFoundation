//
//  AuthRemoteDataSource.swift
//  BaseIOSApp
//

import Foundation
import BaseIOSCore

protocol AuthRemoteDataSourceProtocol {
    func login(email: String, password: String) async throws -> LoginResponseDTO
    func register(email: String, password: String) async throws -> LoginResponseDTO
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
        } catch let ne as NetworkError {
            logger.error("AuthRemoteDataSource login failed: \(ne)")
            if ne.apiCode == "INVALID_CREDENTIALS" { throw AuthError.invalidCredentials }
            throw AuthError.from(ne)
        } catch {
            logger.error("AuthRemoteDataSource login failed: \(error)")
            throw AuthError.from(error)
        }
    }

    func register(email: String, password: String) async throws -> LoginResponseDTO {
        if AppEnvironment.current == .mock {
            return LoginResponseDTO(
                accessToken: "mock_access_\(UUID().uuidString)",
                refreshToken: nil,
                expiresIn: 3600,
                user: nil
            )
        }
        do {
            return try await apiClient.request(
                AuthEndpoint.register(email: email, password: password).endpoint,
                responseType: LoginResponseDTO.self
            )
        } catch let ne as NetworkError {
            logger.error("AuthRemoteDataSource register failed: \(ne)")
            if ne.apiCode == "CONFLICT" { throw AuthError.emailAlreadyRegistered }
            throw AuthError.from(ne)
        } catch {
            logger.error("AuthRemoteDataSource register failed: \(error)")
            throw AuthError.from(error)
        }
    }

    func logout() async throws {
        _ = try await apiClient.request(
            AuthEndpoint.logout.endpoint,
            responseType: EmptyResponse.self
        )
    }
}