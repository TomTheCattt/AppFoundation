//
//  AuthEndpoint.swift
//  BaseIOSApp
//

import Foundation

enum AuthEndpoint {
    case login(email: String, password: String)
    case logout
    case refresh(refreshToken: String)

    var path: String {
        switch self {
        case .login: return "/api/v1/auth/login"
        case .logout: return "/api/v1/auth/logout"
        case .refresh: return "/api/v1/auth/refresh"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .logout: return .post
        case .refresh: return .post
        }
    }

    var body: Data? {
        switch self {
        case .login(let email, let password):
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
