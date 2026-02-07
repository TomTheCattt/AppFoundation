//
//  ErrorMapperTests.swift
//  BaseIOSAppTests
//

import XCTest
@testable import BaseIOSApp

final class ErrorMapperTests: XCTestCase {
    func test_map_URLErrorNotConnected_returnsNetworkError() {
        let mapper = ErrorMapper()
        let urlError = URLError(.notConnectedToInternet)
        let result = mapper.map(urlError)
        XCTAssertTrue(result is DomainError)
    }
}
