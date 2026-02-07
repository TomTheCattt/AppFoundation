//
//  RetryInterceptor.swift
//  BaseIOSApp
//

import Foundation

final class RetryInterceptor: Interceptor {
    private let maxRetries: Int
    private let retryableStatusCodes: Set<Int>

    init(maxRetries: Int = 3, retryableStatusCodes: Set<Int> = [408, 429, 500, 502, 503, 504]) {
        self.maxRetries = maxRetries
        self.retryableStatusCodes = retryableStatusCodes
    }

    func adapt(_ request: URLRequest) async throws -> URLRequest { request }

    func handleResponse(_ response: URLResponse, data: Data) async throws {
        guard let http = response as? HTTPURLResponse else { return }
        if retryableStatusCodes.contains(http.statusCode) {
            // Retry logic is applied at APIClient level with exponential backoff
        }
    }

    func shouldRetry(response: URLResponse?, error: Error?) -> Bool {
        if let http = response as? HTTPURLResponse {
            return retryableStatusCodes.contains(http.statusCode)
        }
        if let urlError = error as? URLError {
            return urlError.code == .timedOut || urlError.code == .networkConnectionLost
        }
        return false
    }

    func retryDelay(for attempt: Int) -> TimeInterval {
        pow(2.0, Double(attempt))
    }
}
