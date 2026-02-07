//
//  LoginUseCaseTests.swift
//  BaseIOSAppTests
//

import XCTest
@testable import BaseIOSApp

final class LoginUseCaseTests: XCTestCase {

    var sut: LoginUseCase!
    var mockRepository: MockAuthRepository!
    var mockTokenStore: MockTokenStore!

    override func setUp() {
        super.setUp()
        mockRepository = MockAuthRepository()
        mockTokenStore = MockTokenStore()
        sut = LoginUseCase(
            repository: mockRepository,
            tokenStore: mockTokenStore,
            logger: Logger.shared
        )
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        mockTokenStore = nil
        super.tearDown()
    }

    func test_execute_success_savesTokens() async throws {
        let session = AuthSession(accessToken: "at1", refreshToken: "rt1", expiresIn: 3600)
        mockRepository.loginResult = .success(session)

        try await sut.execute(email: "u@test.com", password: "pass")

        XCTAssertEqual(mockRepository.loginCallCount, 1)
        XCTAssertEqual(mockTokenStore.setTokensCallCount, 1)
        XCTAssertEqual(mockTokenStore.setTokensAccess, "at1")
        XCTAssertEqual(mockTokenStore.setTokensRefresh, "rt1")
    }

    func test_execute_trimsEmailAndPassword() async throws {
        let session = AuthSession(accessToken: "at", refreshToken: nil, expiresIn: nil)
        mockRepository.loginResult = .success(session)

        try await sut.execute(email: "  u@test.com  ", password: "  pass  ")

        XCTAssertEqual(mockRepository.loginCallCount, 1)
        XCTAssertEqual(mockTokenStore.setTokensAccess, "at")
    }

    func test_execute_emptyEmail_throwsInvalidInput() async {
        do {
            try await sut.execute(email: "", password: "pass")
            XCTFail("Expected AuthError.invalidInput")
        } catch AuthError.invalidInput {
            // expected
        } catch {
            XCTFail("Expected AuthError.invalidInput, got \(error)")
        }
        XCTAssertEqual(mockRepository.loginCallCount, 0)
    }

    func test_execute_emptyPassword_throwsInvalidInput() async {
        do {
            try await sut.execute(email: "u@test.com", password: "")
            XCTFail("Expected AuthError.invalidInput")
        } catch AuthError.invalidInput {
            // expected
        } catch {
            XCTFail("Expected AuthError.invalidInput, got \(error)")
        }
        XCTAssertEqual(mockRepository.loginCallCount, 0)
    }

    func test_execute_whitespaceOnly_throwsInvalidInput() async {
        do {
            try await sut.execute(email: "  ", password: "  ")
            XCTFail("Expected AuthError.invalidInput")
        } catch AuthError.invalidInput {
            // expected
        } catch {
            XCTFail("Expected AuthError.invalidInput, got \(error)")
        }
        XCTAssertEqual(mockRepository.loginCallCount, 0)
    }

    func test_execute_repositoryThrows_propagatesError() async {
        mockRepository.loginResult = .failure(AuthError.invalidCredentials)
        do {
            try await sut.execute(email: "u@test.com", password: "pass")
            XCTFail("Expected throw")
        } catch AuthError.invalidCredentials {
            // expected
        } catch {
            XCTFail("Expected AuthError.invalidCredentials, got \(error)")
        }
        XCTAssertEqual(mockRepository.loginCallCount, 1)
        XCTAssertEqual(mockTokenStore.setTokensCallCount, 0)
    }
}
