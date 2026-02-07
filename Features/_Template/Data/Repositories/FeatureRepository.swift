//
//  FeatureRepository.swift
//  BaseIOSApp
//

import Foundation

final class FeatureRepository: FeatureRepositoryProtocol {
    private let remoteDataSource: FeatureRemoteDataSourceProtocol
    private let localDataSource: FeatureLocalDataSourceProtocol
    private let logger: Logger
    private let networkMonitor: NetworkMonitorProtocol

    init(
        remoteDataSource: FeatureRemoteDataSourceProtocol,
        localDataSource: FeatureLocalDataSourceProtocol,
        logger: Logger,
        networkMonitor: NetworkMonitorProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.logger = logger
        self.networkMonitor = networkMonitor
    }

    func fetchAll() async throws -> [FeatureEntity] {
        if networkMonitor.isConnected {
            do {
                let dtos = try await remoteDataSource.fetchAll()
                let entities = try FeatureDTOMapper.toDomain(dtos)
                try await localDataSource.saveAll(entities)
                return entities
            } catch {
                logger.warning("Remote fetch failed, using local: \(error)")
            }
        }
        return try await localDataSource.fetchAll()
    }

    func fetch(id: String) async throws -> FeatureEntity {
        if let local = try? await localDataSource.fetch(id: id) {
            if networkMonitor.isConnected {
                Task {
                    if let dto = try? await remoteDataSource.fetch(id: id),
                       let entity = try? FeatureDTOMapper.toDomain(dto) {
                        try? await localDataSource.update(entity)
                    }
                }
            }
            return local
        }
        let dto = try await remoteDataSource.fetch(id: id)
        let entity = try FeatureDTOMapper.toDomain(dto)
        try await localDataSource.save(entity)
        return entity
    }

    func create(_ entity: FeatureEntity) async throws -> FeatureEntity {
        if networkMonitor.isConnected {
            let requestDTO = FeatureDTOMapper.toRequestDTO(entity)
            let responseDTO = try await remoteDataSource.create(requestDTO)
            let created = try FeatureDTOMapper.toDomain(responseDTO)
            try await localDataSource.save(created)
            return created
        }
        try await localDataSource.save(entity)
        return entity
    }

    func update(_ entity: FeatureEntity) async throws -> FeatureEntity {
        if networkMonitor.isConnected {
            let requestDTO = FeatureDTOMapper.toRequestDTO(entity)
            let responseDTO = try await remoteDataSource.update(id: entity.id, dto: requestDTO)
            let updated = try FeatureDTOMapper.toDomain(responseDTO)
            try await localDataSource.update(updated)
            return updated
        }
        try await localDataSource.update(entity)
        return entity
    }

    func delete(id: String) async throws {
        if networkMonitor.isConnected {
            try? await remoteDataSource.delete(id: id)
        }
        try await localDataSource.delete(id: id)
    }

    func deleteAll() async throws {
        if networkMonitor.isConnected {
            try? await remoteDataSource.deleteAll()
        }
        try await localDataSource.deleteAll()
    }

    func search(query: String) async throws -> [FeatureEntity] {
        if networkMonitor.isConnected {
            let dtos = try await remoteDataSource.search(query: query)
            return try FeatureDTOMapper.toDomain(dtos)
        }
        return try await localDataSource.search(query: query)
    }
}
