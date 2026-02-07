//
//  StorageAssembly.swift
//  BaseIOSApp
//

import Foundation
import Swinject

final class StorageAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DatabaseEncryptionProvider.self) { _ in DatabaseEncryptionProvider.shared }
            .inObjectScope(.container)

        // Default: InMemoryDatabase (builds without Realm). To use Realm: add RealmSwift SPM and return RealmDatabase(configuration: config).
        container.register(LocalDatabaseProtocol.self) { _ in
            InMemoryDatabase()
        }.inObjectScope(.container)

        container.register(CacheProtocol.self) { _ in MemoryCache() }
    }
}
