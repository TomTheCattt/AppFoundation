//
//  TokenStore.swift
//  BaseIOSApp
//
//  Persists access & refresh tokens in Keychain. Used by AuthInterceptor and Auth feature.
//

import Foundation

protocol TokenStoreProtocol: AnyObject {
    var accessToken: String? { get }
    var refreshToken: String? { get }
    var isAuthenticated: Bool { get }
    func setTokens(access: String?, refresh: String?) throws
    func clearTokens() throws
}

private enum TokenStoreKey {
    static let access = "auth_access_token"
    static let refresh = "auth_refresh_token"
}

final class TokenStore: TokenStoreProtocol {
    private let keychain: KeychainManager
    private let lock = NSLock()
    private var _accessToken: String?
    private var _refreshToken: String?

    var accessToken: String? {
        lock.lock()
        defer { lock.unlock() }
        if _accessToken == nil { _accessToken = (try? keychain.load(forKey: TokenStoreKey.access)).flatMap { String(data: $0, encoding: .utf8) } }
        return _accessToken
    }

    var refreshToken: String? {
        lock.lock()
        defer { lock.unlock() }
        if _refreshToken == nil { _refreshToken = (try? keychain.load(forKey: TokenStoreKey.refresh)).flatMap { String(data: $0, encoding: .utf8) } }
        return _refreshToken
    }

    var isAuthenticated: Bool { accessToken != nil }

    init(keychain: KeychainManager = .shared) {
        self.keychain = keychain
    }

    func setTokens(access: String?, refresh: String?) throws {
        lock.lock()
        defer { lock.unlock() }
        if let access = access, let data = access.data(using: .utf8) {
            try keychain.save(data, forKey: TokenStoreKey.access)
        } else {
            try? keychain.delete(forKey: TokenStoreKey.access)
        }
        if let refresh = refresh, let data = refresh.data(using: .utf8) {
            try keychain.save(data, forKey: TokenStoreKey.refresh)
        } else {
            try? keychain.delete(forKey: TokenStoreKey.refresh)
        }
        _accessToken = access
        _refreshToken = refresh
    }

    func clearTokens() throws {
        try setTokens(access: nil, refresh: nil)
    }
}
