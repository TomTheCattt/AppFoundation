//
//  AuthSession.swift
//  BaseIOSApp
//

import Foundation

/// Represents a successful login. Tokens are persisted via TokenStore in the Auth use case.
struct AuthSession: Equatable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: TimeInterval?

    init(accessToken: String, refreshToken: String? = nil, expiresIn: TimeInterval? = nil) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
    }
}
