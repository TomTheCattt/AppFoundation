//
//  DatabaseConfiguration.swift
//  AppFoundation
//

import Foundation

struct DatabaseConfiguration {
    let databaseName: String
    let schemaVersion: UInt64
    let encryptionKey: Data?
    let shouldMigrateAutomatically: Bool
    let inMemoryIdentifier: String?

    static var production: DatabaseConfiguration {
        DatabaseConfiguration(
            databaseName: AppConstants.Storage.databaseName,
            schemaVersion: 1,
            encryptionKey: DatabaseEncryptionProvider.shared.getKey(),
            shouldMigrateAutomatically: true,
            inMemoryIdentifier: nil
        )
    }

    static var test: DatabaseConfiguration {
        DatabaseConfiguration(
            databaseName: "Test",
            schemaVersion: 1,
            encryptionKey: nil,
            shouldMigrateAutomatically: true,
            inMemoryIdentifier: "test"
        )
    }
}
