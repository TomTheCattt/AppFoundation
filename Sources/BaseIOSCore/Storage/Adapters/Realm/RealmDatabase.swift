//
//  RealmDatabase.swift
//  BaseIOSApp
//
//  Default database implementation using Realm. Add RealmSwift via SPM.
//

import Foundation
import RealmSwift

final class RealmDatabase: LocalDatabaseProtocol {
    private let configuration: Realm.Configuration

    init(configuration: DatabaseConfiguration) {
        var realmConfig = Realm.Configuration()
        realmConfig.schemaVersion = configuration.schemaVersion
        realmConfig.encryptionKey = configuration.encryptionKey
        if let inMemory = configuration.inMemoryIdentifier {
            realmConfig.inMemoryIdentifier = inMemory
        } else {
            let fileURL = realmConfig.fileURL?
                .deletingLastPathComponent()
                .appendingPathComponent("\(configuration.databaseName).realm")
            realmConfig.fileURL = fileURL
        }
        realmConfig.migrationBlock = { migration, oldVersion in
            RealmMigration.migrate(migration: migration, oldSchemaVersion: oldVersion)
        }
        self.configuration = realmConfig
    }

    private func getRealm() throws -> Realm {
        try Realm(configuration: configuration)
    }

    func create<T: Storable>(_ object: T) async throws {
        let realm = try getRealm()
        try realm.write {
            if let obj = object as? Object {
                realm.add(obj)
            }
        }
    }

    func read<T: Storable>(type: T.Type, primaryKey: Any) async throws -> T? {
        let realm = try getRealm()
        guard let objectType = type as? Object.Type else { return nil }
        return realm.object(ofType: objectType, forPrimaryKey: primaryKey) as? T
    }

    func update<T: Storable>(_ object: T) async throws {
        try await create(object)
    }

    func delete<T: Storable>(_ object: T) async throws {
        let realm = try getRealm()
        try realm.write {
            if let obj = object as? Object {
                realm.delete(obj)
            }
        }
    }

    func createAll<T: Storable>(_ objects: [T]) async throws {
        let realm = try getRealm()
        try realm.write {
            objects.compactMap { $0 as? Object }.forEach { realm.add($0) }
        }
    }

    func deleteAll<T: Storable>(type: T.Type) async throws {
        let realm = try getRealm()
        guard let objectType = type as? Object.Type else { return }
        try realm.write {
            realm.delete(realm.objects(objectType))
        }
    }

    func fetch<T: Storable>(
        type: T.Type,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?
    ) async throws -> [T] {
        let realm = try getRealm()
        guard let objectType = type as? Object.Type else { return [] }
        var results = realm.objects(objectType)
        if let p = predicate {
            results = results.filter(p)
        }
        if let sort = sortDescriptors?.first, let key = sort.key {
            results = results.sorted(byKeyPath: key, ascending: sort.ascending)
        }
        return Array(results).compactMap { $0 as? T }
    }

    func performTransaction(_ block: @escaping () -> Void) async throws {
        let realm = try getRealm()
        try realm.write(block)
    }
}
