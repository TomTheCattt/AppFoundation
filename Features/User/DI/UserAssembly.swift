//
//  UserAssembly.swift
//  BaseIOSApp
//

import Foundation
import Swinject

final class UserAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UserRemoteDataSourceProtocol.self) { r in
            UserRemoteDataSource(
                apiClient: r.resolve(APIClientProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }.inObjectScope(.container)

        container.register(UserRepositoryProtocol.self) { r in
            UserRepository(
                remoteDataSource: r.resolve(UserRemoteDataSourceProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }.inObjectScope(.container)

        container.register(GetCurrentUserUseCaseProtocol.self) { r in
            GetCurrentUserUseCase(
                repository: r.resolve(UserRepositoryProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }
    }
}
