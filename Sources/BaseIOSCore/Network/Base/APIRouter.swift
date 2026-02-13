//
//  APIRouter.swift
//  BaseIOSCore
//
//  Created by BaseIOSApp Package.
//

import Foundation

/// Protocol for defining API Routes in a centralized Enum
public protocol APIRoute {
    var path: String { get }
    var method: HTTPMethod { get }
}

// Example of how Consumer App defines Routes:
/*
enum AuthRoute: APIRoute {
    case login
    case register
    case profile
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .register: return "/auth/register"
        case .profile: return "/users/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .register: return .post
        case .profile: return .get
        }
    }
}
*/

// Extension to use Route directly in APIClient
extension APIClient {
    public func request<T: Decodable>(
        route: APIRoute,
        params: [String: Any]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(
            path: route.path,
            method: route.method,
            params: params,
            responseType: responseType
        )
    }
}
