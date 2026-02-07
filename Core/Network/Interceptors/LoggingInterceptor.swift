//
//  LoggingInterceptor.swift
//  BaseIOSApp
//

import Foundation

final class LoggingInterceptor: Interceptor {
    private let logger: Logger

    init(logger: Logger = .shared) {
        self.logger = logger
    }

    func adapt(_ request: URLRequest) async throws -> URLRequest {
        logger.debug("""
        REQUEST
        URL: \(request.url?.absoluteString ?? "")
        Method: \(request.httpMethod ?? "")
        """)
        return request
    }

    func handleResponse(_ response: URLResponse, data: Data) async throws {
        guard let http = response as? HTTPURLResponse else { return }
        logger.debug("""
        RESPONSE
        URL: \(http.url?.absoluteString ?? "")
        Status: \(http.statusCode)
        """)
    }
}
