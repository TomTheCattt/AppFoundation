//
//  AuthMocks.swift
//  AppFoundationTests
//

import Foundation
@testable import AppFoundation

// MARK: - Mock AuthRepository (for LoginUseCase tests)

final class MockAuthRepository: AuthRepositoryProtocol {
    var loginResult: Result<AuthSession, Error> = .failure(AuthError.invalidCredentials)
    var registerResult: Result<AuthSession, Error> = .failure(AuthError.emailAlreadyRegistered)
    var loginCallCount = 0
    var registerCallCount = 0
    var logoutCallCount = 0

    func login(email: String, password: String) async throws -> AuthSession {
        loginCallCount += 1
        switch loginResult {
        case .success(let session): return session
        case .failure(let error): throw error
        }
    }

    func register(email: String, password: String) async throws -> AuthSession {
        registerCallCount += 1
        switch registerResult {
        case .success(let session): return session
        case .failure(let error): throw error
        }
    }

    func logout() async throws {
        logoutCallCount += 1
    }
}

// MARK: - Mock TokenStore (for LoginUseCase tests)

final class MockTokenStore: TokenStoreProtocol {
    var accessToken: String?
    var refreshToken: String?
    var setTokensCallCount = 0
    var setTokensAccess: String?
    var setTokensRefresh: String?
    var clearTokensCallCount = 0

    var isAuthenticated: Bool { accessToken != nil }

    func setTokens(access: String?, refresh: String?) throws {
        setTokensCallCount += 1
        setTokensAccess = access
        setTokensRefresh = refresh
        accessToken = access
        refreshToken = refresh
    }

    func clearTokens() throws {
        clearTokensCallCount += 1
        accessToken = nil
        refreshToken = nil
    }
}

// MARK: - Mock AuthRemoteDataSource (for AuthRepository tests)

final class MockAuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    var loginResult: Result<LoginResponseDTO, Error> = .failure(AuthError.networkError(NSError(domain: "test", code: -1, userInfo: nil)))
    var registerResult: Result<LoginResponseDTO, Error> = .failure(AuthError.emailAlreadyRegistered)
    var loginCallCount = 0
    var registerCallCount = 0
    var logoutCallCount = 0

    func login(email: String, password: String) async throws -> LoginResponseDTO {
        loginCallCount += 1
        switch loginResult {
        case .success(let dto): return dto
        case .failure(let error): throw error
        }
    }

    func register(email: String, password: String) async throws -> LoginResponseDTO {
        registerCallCount += 1
        switch registerResult {
        case .success(let dto): return dto
        case .failure(let error): throw error
        }
    }

    func logout() async throws {
        logoutCallCount += 1
    }
}
