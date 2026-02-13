//
//  RealmConfiguration.swift
//  AppFoundation
//

import Foundation
import RealmSwift

final class RealmConfiguration {
    static func production() -> Realm.Configuration {
        var config = Realm.Configuration()
        config.schemaVersion = 1
        config.encryptionKey = DatabaseEncryptionProvider.shared.getKey()
        return config
    }

    static func inMemory(identifier: String) -> Realm.Configuration {
        var config = Realm.Configuration()
        config.inMemoryIdentifier = identifier
        return config
    }
}
