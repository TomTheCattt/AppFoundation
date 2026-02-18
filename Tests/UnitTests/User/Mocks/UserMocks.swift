//
//  UserMocks.swift
//  AppFoundationTests
//

import Foundation
@testable import AppFoundation

// MARK: - Mock UserRepository (for GetCurrentUserUseCase tests)

final class MockUserRepository: UserRepositoryProtocol {
    var getCurrentUserResult: Result<UserEntity, Error> = .failure(UserError.notFound)
    var getCurrentUserCallCount = 0

    func getCurrentUser() async throws -> UserEntity {
        getCurrentUserCallCount += 1
        switch getCurrentUserResult {
        case .success(let user): return user
        case .failure(let error): throw error
        }
    }
}
