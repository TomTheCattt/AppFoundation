//
//  ErrorMapper.swift
//  BaseIOSApp
//

import Foundation

final class ErrorMapper {
    func map(_ error: Error) -> AppErrorProtocol {
        if let appError = error as? AppErrorProtocol { return appError }
        if let net = error as? NetworkError { return DomainError.network(net) }
        if let urlError = error as? URLError { return DomainError.network(mapURLError(urlError)) }
        if error is DecodingError { return DomainError.network(.decodingFailed(error)) }
        return DomainError.unknown(error)
    }

    private func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost: return .noInternetConnection
        case .timedOut: return .timeout
        default: return .unknown(error)
        }
    }
}
