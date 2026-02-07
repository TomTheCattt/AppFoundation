//
//  FeatureError.swift
//  BaseIOSApp
//

import Foundation

enum FeatureError: Error, LocalizedError {
    case validation(ValidationError)
    case notFound(id: String)
    case alreadyExists(id: String)
    case unauthorized
    case serverError(String)
    case networkError(Error)
    case unknown(Error)

    enum ValidationError {
        case emptyTitle
        case titleTooLong
        case invalidPriority
    }

    var errorDescription: String? {
        switch self {
        case .validation(let error):
            switch error {
            case .emptyTitle: return "Title cannot be empty"
            case .titleTooLong: return "Title too long (max 100)"
            case .invalidPriority: return "Priority must be 0-10"
            }
        case .notFound(let id): return "Feature \(id) not found"
        case .alreadyExists(let id): return "Feature \(id) already exists"
        case .unauthorized: return "Unauthorized"
        case .serverError(let msg): return "Server error: \(msg)"
        case .networkError(let error): return "Network error: \(error.localizedDescription)"
        case .unknown(let error): return "Unknown error: \(error.localizedDescription)"
        }
    }

    /// Map generic Error to FeatureError (use in Use Cases / Repository).
    static func from(_ error: Error) -> FeatureError {
        if let featureError = error as? FeatureError { return featureError }
        if (error as NSError).domain == NSURLErrorDomain { return .networkError(error) }
        return .unknown(error)
    }
}
