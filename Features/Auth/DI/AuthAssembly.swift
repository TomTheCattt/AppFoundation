//
//  AuthAssembly.swift
//  BaseIOSApp
//

import Foundation
import Swinject

final class AuthAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthRemoteDataSourceProtocol.self) { r in
            AuthRemoteDataSource(
                apiClient: r.resolve(APIClientProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }.inObjectScope(.container)

        container.register(AuthRepositoryProtocol.self) { r in
            AuthRepository(
                remoteDataSource: r.resolve(AuthRemoteDataSourceProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }.inObjectScope(.container)

        container.register(LoginUseCaseProtocol.self) { r in
            LoginUseCase(
                repository: r.resolve(AuthRepositoryProtocol.self)!,
                tokenStore: r.resolve(TokenStoreProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }

        container.register(LogoutUseCaseProtocol.self) { r in
            LogoutUseCase(
                repository: r.resolve(AuthRepositoryProtocol.self)!,
                tokenStore: r.resolve(TokenStoreProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }

        container.register(RegisterUseCaseProtocol.self) { r in
            RegisterUseCase(
                repository: r.resolve(AuthRepositoryProtocol.self)!,
                tokenStore: r.resolve(TokenStoreProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }
    }
}
