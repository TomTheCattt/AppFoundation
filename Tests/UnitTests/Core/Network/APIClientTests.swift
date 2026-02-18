//
//  APIClientTests.swift
//  AppFoundationTests
//

import XCTest
@testable import AppFoundation

final class APIClientTests: XCTestCase {
    func test_requestBuilder_buildsValidRequest() throws {
        let endpoint = Endpoint.get("/users", query: ["page": 1])
        let request = try RequestBuilder.build(endpoint, baseURL: "https://api.example.com")
        XCTAssertEqual(request.url?.absoluteString, "https://api.example.com/users?page=1")
        XCTAssertEqual(request.httpMethod, "GET")
    }
}
