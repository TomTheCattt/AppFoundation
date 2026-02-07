//
//  UserRepository.swift
//  BaseIOSApp
//

import Foundation

final class UserRepository: UserRepositoryProtocol {
    private let remoteDataSource: UserRemoteDataSourceProtocol
    private let logger: Logger

    init(remoteDataSource: UserRemoteDataSourceProtocol, logger: Logger) {
        self.remoteDataSource = remoteDataSource
        self.logger = logger
    }

    func getCurrentUser() async throws -> UserEntity {
        let dto = try await remoteDataSource.getCurrentUser()
        return UserDTOMapper.toEntity(dto)
    }
}
