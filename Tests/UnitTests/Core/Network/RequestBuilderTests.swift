//
//  RequestBuilderTests.swift
//  BaseIOSAppTests
//

import XCTest
@testable import BaseIOSApp

final class RequestBuilderTests: XCTestCase {
    func test_build_withQueryParams() throws {
        let endpoint = Endpoint(path: "/test", queryParameters: ["a": "b"])
        let request = try RequestBuilder.build(endpoint, baseURL: "https://example.com")
        XCTAssertNotNil(request.url)
        XCTAssertTrue(request.url?.absoluteString.contains("a=b") == true)
    }
}
