//
//  UserError.swift
//  BaseIOSApp
//

import Foundation

enum UserError: Error, LocalizedError {
    case notFound
    case serverError(String)
    case networkError(Error)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .notFound: return "User not found"
        case .serverError(let msg): return "Server error: \(msg)"
        case .networkError(let e): return "Network error: \(e.localizedDescription)"
        case .unknown(let e): return e.localizedDescription
        }
    }

    static func from(_ error: Error) -> UserError {
        if let u = error as? UserError { return u }
        if (error as NSError).domain == NSURLErrorDomain { return .networkError(error) }
        return .unknown(error)
    }
}
