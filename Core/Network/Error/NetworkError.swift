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
    case serverError(statusCode: Int, message: String?, apiCode: String?)
    case unauthorized(apiCode: String?)
    case forbidden(apiCode: String?)
    case notFound(apiCode: String?)
    case unknown(Error)

    var userMessage: String {
        switch self {
        case .noInternetConnection: return "No internet connection. Please check your network."
        case .timeout: return "Request timeout. Please try again."
        case .unauthorized: return "Session expired. Please sign in again."
        case .forbidden: return "You don't have permission."
        case .notFound: return "Resource not found."
        case .serverError(_, let msg, _): return msg ?? "Server error. Please try again later."
        case .decodingFailed, .invalidURL, .unknown: return "Something went wrong. Please try again."
        }
    }

    /// Mã lỗi từ server (vd: INVALID_CREDENTIALS, UNAUTHORIZED, NOT_FOUND) để client map sang domain error.
    var apiCode: String? {
        switch self {
        case .serverError(_, _, let code): return code
        case .unauthorized(let code): return code
        case .forbidden(let code): return code
        case .notFound(let code): return code
        default: return nil
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
