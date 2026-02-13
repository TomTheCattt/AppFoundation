//
//  AppError.swift
//  AppFoundation
//

import Foundation
import UIKit

protocol AppErrorProtocol: Error {
    var title: String { get }
    var message: String { get }
    var code: String { get }
    var isRecoverable: Bool { get }
    var recoveryStrategy: ErrorRecoveryStrategy? { get }
}

enum DomainError: AppErrorProtocol {
    case network(NetworkError)
    case storage(StorageError)
    case validation(ValidationError)
    case business(BusinessError)
    case unknown(Error)

    var title: String {
        switch self {
        case .network: return "Network Error"
        case .storage: return "Storage Error"
        case .validation: return "Validation Error"
        case .business: return "Error"
        case .unknown: return "Unexpected Error"
        }
    }

    var message: String {
        switch self {
        case .network(let e): return e.userMessage
        case .storage(let e): return e.localizedDescription
        case .validation(let e): return e.message
        case .business(let e): return e.message
        case .unknown(let e): return e.localizedDescription
        }
    }

    var code: String {
        switch self {
        case .network: return "NET_ERR"
        case .storage: return "DB_ERR"
        case .validation: return "VAL_ERR"
        case .business: return "BUS_ERR"
        case .unknown: return "UNK_ERR"
        }
    }

    var isRecoverable: Bool {
        switch self {
        case .network(let e): return e.isRecoverable
        case .storage, .validation, .business, .unknown: return true
        }
    }

    var recoveryStrategy: ErrorRecoveryStrategy? { nil }
}

enum StorageError: Error {
    case saveFailed
    case loadFailed
    case notFound
}

enum ValidationError: Error {
    case invalidInput(String)
    var message: String { if case .invalidInput(let m) = self { return m }; return "" }
}

enum BusinessError: Error {
    case generic(String)
    var message: String { if case .generic(let m) = self { return m }; return "" }
}
