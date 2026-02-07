//
//  MockServerManager.swift
//  BaseIOSApp
//

import Foundation

final class MockServerManager {
    static let shared = MockServerManager()

    struct MockResponse {
        let data: Data
        let statusCode: Int
        let delay: TimeInterval
    }

    private var mocks: [String: MockResponse] = [:]

    private init() {}

    func register(path: String, jsonFileName: String, statusCode: Int = 200, delay: TimeInterval = 0.5) {
        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            Logger.shared.error("Failed to load mock file: \(jsonFileName)")
            return
        }
        mocks[path] = MockResponse(data: data, statusCode: statusCode, delay: delay)
    }

    func mockResponse(for url: URL) -> MockResponse? {
        let path = url.path
        return mocks[path]
    }
}
