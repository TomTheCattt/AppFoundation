//
//  NetworkError.swift
//  BaseIOSApp
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noInternetConnection
    case timeout
    case decodingFailed(Error)
    case serverError(statusCode: Int, message: String?)
    case unauthorized
    case forbidden
    case notFound
    case unknown(Error)

    var userMessage: String {
        switch self {
        case .noInternetConnection: return "No internet connection. Please check your network."
        case .timeout: return "Request timeout. Please try again."
        case .unauthorized: return "Session expired. Please sign in again."
        case .forbidden: return "You don't have permission."
        case .notFound: return "Resource not found."
        case .serverError(_, let msg): return msg ?? "Server error. Please try again later."
        case .decodingFailed, .invalidURL, .unknown: return "Something went wrong. Please try again."
        }
    }

    var isRecoverable: Bool {
        switch self {
        case .timeout, .noInternetConnection: return true
        case .unauthorized, .forbidden: return false
        default: return true
        }
    }
}
