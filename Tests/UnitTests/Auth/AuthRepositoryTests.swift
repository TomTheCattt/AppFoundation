//
//  AuthRepositoryTests.swift
//  AppFoundationTests
//

import XCTest
@testable import AppFoundation

final class AuthRepositoryTests: XCTestCase {

    var sut: AuthRepository!
    var mockDataSource: MockAuthRemoteDataSource!

    override func setUp() {
        super.setUp()
        mockDataSource = MockAuthRemoteDataSource()
        sut = AuthRepository(
            remoteDataSource: mockDataSource,
            logger: Logger.shared
        )
    }

    override func tearDown() {
        sut = nil
        mockDataSource = nil
        super.tearDown()
    }

    func test_login_success_mapsDTOToSession() async throws {
        let json = """
        {"access_token": "at_123", "refresh_token": "rt_456", "expires_in": 7200}
        """
        let dto = try JSONDecoder().decode(LoginResponseDTO.self, from: json.data(using: .utf8)!)
        mockDataSource.loginResult = .success(dto)

        let session = try await sut.login(email: "u@test.com", password: "pwd")

        XCTAssertEqual(session.accessToken, "at_123")
        XCTAssertEqual(session.refreshToken, "rt_456")
        XCTAssertEqual(session.expiresIn, 7200)
        XCTAssertEqual(mockDataSource.loginCallCount, 1)
    }

    func test_login_success_nullRefreshToken() async throws {
        let json = """
        {"access_token": "at", "refresh_token": null, "expires_in": 3600}
        """
        let dto = try JSONDecoder().decode(LoginResponseDTO.self, from: json.data(using: .utf8)!)
        mockDataSource.loginResult = .success(dto)

        let session = try await sut.login(email: "u@test.com", password: "pwd")

        XCTAssertEqual(session.accessToken, "at")
        XCTAssertNil(session.refreshToken)
        XCTAssertEqual(session.expiresIn, 3600)
    }

    func test_login_remoteThrows_propagatesError() async {
        mockDataSource.loginResult = .failure(AuthError.invalidCredentials)
        do {
            _ = try await sut.login(email: "u@test.com", password: "pwd")
            XCTFail("Expected throw")
        } catch AuthError.invalidCredentials {
            // expected
        } catch {
            XCTFail("Expected AuthError.invalidCredentials, got \(error)")
        }
        XCTAssertEqual(mockDataSource.loginCallCount, 1)
    }

    func test_logout_callsRemote() async throws {
        try await sut.logout()
        XCTAssertEqual(mockDataSource.logoutCallCount, 1)
    }
}
