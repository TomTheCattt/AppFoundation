//
//  FeatureAssembly.swift
//  BaseIOSApp
//

import Foundation
import Swinject

final class FeatureAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FeatureRemoteDataSourceProtocol.self) { r in
            FeatureRemoteDataSource(
                apiClient: r.resolve(APIClientProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }.inObjectScope(.container)

        container.register(FeatureLocalDataSourceProtocol.self) { r in
            FeatureLocalDataSource(
                database: r.resolve(LocalDatabaseProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }.inObjectScope(.container)

        container.register(FeatureRepositoryProtocol.self) { r in
            FeatureRepository(
                remoteDataSource: r.resolve(FeatureRemoteDataSourceProtocol.self)!,
                localDataSource: r.resolve(FeatureLocalDataSourceProtocol.self)!,
                logger: r.resolve(Logger.self)!,
                networkMonitor: r.resolve(NetworkMonitorProtocol.self)!
            )
        }.inObjectScope(.container)

        container.register(FetchFeatureUseCaseProtocol.self) { r in
            FetchFeatureUseCase(
                repository: r.resolve(FeatureRepositoryProtocol.self)!,
                logger: r.resolve(Logger.self)!,
                cacheManager: r.resolve(CacheProtocol.self)!
            )
        }

        container.register(CreateFeatureUseCaseProtocol.self) { r in
            CreateFeatureUseCase(
                repository: r.resolve(FeatureRepositoryProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }

        container.register(UpdateFeatureUseCaseProtocol.self) { r in
            UpdateFeatureUseCase(
                repository: r.resolve(FeatureRepositoryProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }

        container.register(DeleteFeatureUseCaseProtocol.self) { r in
            DeleteFeatureUseCase(
                repository: r.resolve(FeatureRepositoryProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }
    }
}
