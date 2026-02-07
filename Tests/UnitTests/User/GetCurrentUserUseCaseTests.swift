//
//  GetCurrentUserUseCaseTests.swift
//  BaseIOSAppTests
//

import XCTest
@testable import BaseIOSApp

final class GetCurrentUserUseCaseTests: XCTestCase {

    var sut: GetCurrentUserUseCase!
    var mockRepository: MockUserRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        sut = GetCurrentUserUseCase(
            repository: mockRepository,
            logger: Logger.shared
        )
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func test_execute_returnsUserFromRepository() async throws {
        let user = UserEntity(id: "u1", email: "u@test.com", name: "User One", avatarURL: nil)
        mockRepository.getCurrentUserResult = .success(user)

        let result = try await sut.execute()

        XCTAssertEqual(result.id, "u1")
        XCTAssertEqual(result.email, "u@test.com")
        XCTAssertEqual(result.name, "User One")
        XCTAssertEqual(mockRepository.getCurrentUserCallCount, 1)
    }

    func test_execute_repositoryThrows_propagatesError() async {
        mockRepository.getCurrentUserResult = .failure(UserError.notFound)
        do {
            _ = try await sut.execute()
            XCTFail("Expected throw")
        } catch UserError.notFound {
            // expected
        } catch {
            XCTFail("Expected UserError.notFound, got \(error)")
        }
        XCTAssertEqual(mockRepository.getCurrentUserCallCount, 1)
    }
}
