//
//  AuthEndpoint.swift
//  AppFoundation
//

import Foundation
import AppFoundation

enum AuthEndpoint {
    case login(email: String, password: String)
    case register(email: String, password: String)
    case logout
    case refresh(refreshToken: String)

    /// Paths relative to base URL (base already includes /api/v1 per BackendIntegrationGuide).
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .register: return "/auth/register"
        case .logout: return "/auth/logout"
        case .refresh: return "/auth/refresh"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .register, .logout, .refresh: return .post
        }
    }

    var body: Data? {
        switch self {
        case .login(let email, let password):
            return try? JSONEncoder().encode(LoginRequestDTO(email: email, password: password))
        case .register(let email, let password):
            return try? JSONEncoder().encode(LoginRequestDTO(email: email, password: password))
        case .logout: return nil
        case .refresh(let token):
            return try? JSONEncoder().encode(["refresh_token": token])
        }
    }

    var endpoint: Endpoint {
        Endpoint(
            path: path,
            method: method,
            headers: ["Content-Type": "application/json", "Accept": "application/json"],
            body: body
        )
    }
}
