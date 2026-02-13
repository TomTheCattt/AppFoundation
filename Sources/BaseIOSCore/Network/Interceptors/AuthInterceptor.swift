//
//  AuthInterceptor.swift
//  BaseIOSApp
//
//  Injects Bearer token from TokenStore. On 401 clears tokens (re-login required).
//  Optional: Phase 4+ can add refresh token flow via Auth feature.
//

import Foundation
import Alamofire

public final class AuthInterceptor: RequestInterceptor {
    private let tokenStore: TokenStoreProtocol
    private let logger: Logger
    private let refreshAction: (() async throws -> Bool)?
    private var isRefreshing = false
    
    init(tokenStore: TokenStoreProtocol, logger: Logger, refreshAction: (() async throws -> Bool)? = nil) {
        self.tokenStore = tokenStore
        self.logger = logger
        self.refreshAction = refreshAction
    }

    public func adapt(_ urlRequest: URLRequest, for session: Alamofire.Session, completion: @escaping (Result<URLRequest, Swift.Error>) -> Void) {
        var modified = urlRequest
        if let token = tokenStore.accessToken {
            modified.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(modified))
    }

    public func retry(_ request: Alamofire.Request, for session: Alamofire.Session, dueTo error: Swift.Error, completion: @escaping (Alamofire.RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        guard let refreshAction = refreshAction else {
            // No refresh action configured, just clear tokens
            try? tokenStore.clearTokens()
            completion(.doNotRetry)
            return
        }
        
        guard !isRefreshing else {
            // Already refreshing, retry with delay to wait for new token
            completion(.retryWithDelay(1.0))
            return
        }
        
        isRefreshing = true
        
        Task {
            do {
                logger.info("AuthInterceptor: 401 received, attempting refresh")
                let success = try await refreshAction()
                isRefreshing = false
                if success {
                    completion(.retry)
                } else {
                    try? tokenStore.clearTokens()
                    completion(.doNotRetry)
                }
            } catch {
                isRefreshing = false
                try? tokenStore.clearTokens()
                completion(.doNotRetry)
            }
        }
    }
}
