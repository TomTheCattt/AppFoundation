//
//  MockServerInterceptor.swift
//  AppFoundation
//

import Foundation

struct MockDataAvailable: Error {
    let data: Data
}

final class MockServerInterceptor: Interceptor {
    private let mockManager: MockServerManager

    init(mockManager: MockServerManager = .shared) {
        self.mockManager = mockManager
    }

    func adapt(_ request: URLRequest) async throws -> URLRequest {
        guard AppEnvironment.current == .mock else { return request }
        var modified = request
        modified.setValue("true", forHTTPHeaderField: "X-Mock-Request")
        return modified
    }

    func handleResponse(_ response: URLResponse, data: Data) async throws {
        if let url = (response as? HTTPURLResponse)?.url,
           let mock = mockManager.mockResponse(for: url) {
            try await Task.sleep(nanoseconds: UInt64(mock.delay * 1_000_000_000))
            throw MockDataAvailable(data: mock.data)
        }
    }
}
