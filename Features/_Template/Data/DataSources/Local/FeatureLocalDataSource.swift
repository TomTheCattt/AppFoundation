//
//  FeatureLocalDataSource.swift
//  BaseIOSApp
//

import Foundation

protocol FeatureLocalDataSourceProtocol {
    func fetchAll() async throws -> [FeatureEntity]
    func fetch(id: String) async throws -> FeatureEntity
    func save(_ entity: FeatureEntity) async throws
    func saveAll(_ entities: [FeatureEntity]) async throws
    func update(_ entity: FeatureEntity) async throws
    func delete(id: String) async throws
    func deleteAll() async throws
    func search(query: String) async throws -> [FeatureEntity]
}

final class FeatureLocalDataSource: FeatureLocalDataSourceProtocol {
    private let database: LocalDatabaseProtocol
    private let logger: Logger

    init(database: LocalDatabaseProtocol, logger: Logger) {
        self.database = database
        self.logger = logger
    }

    func fetchAll() async throws -> [FeatureEntity] {
        let records: [FeatureRecord] = try await database.fetch(
            type: FeatureRecord.self,
            predicate: nil,
            sortDescriptors: nil
        )
        let entities = records.compactMap { $0.toEntity() }
        return entities.sorted { $0.priority > $1.priority }
    }

    func fetch(id: String) async throws -> FeatureEntity {
        guard let record = try await database.read(type: FeatureRecord.self, primaryKey: id),
              let entity = record.toEntity() else {
            throw FeatureError.notFound(id: id)
        }
        return entity
    }

    func save(_ entity: FeatureEntity) async throws {
        try await database.create(FeatureRecord.from(entity))
    }

    func saveAll(_ entities: [FeatureEntity]) async throws {
        let records = entities.map { FeatureRecord.from($0) }
        try await database.createAll(records)
    }

    func update(_ entity: FeatureEntity) async throws {
        try await database.update(FeatureRecord.from(entity))
    }

    func delete(id: String) async throws {
        let entity = try await fetch(id: id)
        try await database.delete(FeatureRecord.from(entity))
    }

    func deleteAll() async throws {
        try await database.deleteAll(type: FeatureRecord.self)
    }

    func search(query: String) async throws -> [FeatureEntity] {
        let predicate = NSPredicate(
            format: "title CONTAINS[cd] %@ OR description CONTAINS[cd] %@",
            query, query
        )
        let records: [FeatureRecord] = try await database.fetch(
            type: FeatureRecord.self,
            predicate: predicate,
            sortDescriptors: nil
        )
        return records.compactMap { $0.toEntity() }
    }
}
