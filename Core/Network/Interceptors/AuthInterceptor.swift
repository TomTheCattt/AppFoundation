//
//  AuthInterceptor.swift
//  BaseIOSApp
//
//  Injects Bearer token from TokenStore. On 401 clears tokens (re-login required).
//  Optional: Phase 4+ can add refresh token flow via Auth feature.
//

import Foundation

final class AuthInterceptor: Interceptor {
    private let tokenStore: TokenStoreProtocol
    private let logger: Logger

    init(tokenStore: TokenStoreProtocol, logger: Logger) {
        self.tokenStore = tokenStore
        self.logger = logger
    }

    func adapt(_ request: URLRequest) async throws -> URLRequest {
        var modified = request
        if let token = tokenStore.accessToken {
            modified.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return modified
    }

    func handleResponse(_ response: URLResponse, data: Data) async throws {
        guard let http = response as? HTTPURLResponse, http.statusCode == 401 else { return }
        logger.warning("AuthInterceptor: 401 received, clearing tokens")
        try? tokenStore.clearTokens()
        // App can observe token change or retry will fail and show login again
    }
}
