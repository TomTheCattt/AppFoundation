//
//  AuthError.swift
//  AppFoundation
//

import Foundation
import AppFoundation

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case emailAlreadyRegistered
    case invalidInput
    case serverError(String)
    case networkError(Error)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "Invalid email or password"
        case .emailAlreadyRegistered: return "Email already registered"
        case .invalidInput: return "Please check your input"
        case .serverError(let msg): return "Server error: \(msg)"
        case .networkError(let e): return "Network error: \(e.localizedDescription)"
        case .unknown(let e): return e.localizedDescription
        }
    }

    static func from(_ error: Error) -> AuthError {
        if let auth = error as? AuthError { return auth }
        if let ne = error as? NetworkError {
            if let code = ne.apiCode {
                if code == "INVALID_CREDENTIALS" { return .invalidCredentials }
                if code == "CONFLICT" { return .emailAlreadyRegistered }
            }
            return .serverError(ne.userMessage)
        }
        if (error as NSError).domain == NSURLErrorDomain { return .networkError(error) }
        return .unknown(error)
    }
}
