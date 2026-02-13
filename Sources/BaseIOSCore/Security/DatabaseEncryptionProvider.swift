//
//  DatabaseEncryptionProvider.swift
//  BaseIOSApp
//

import Foundation

final class DatabaseEncryptionProvider {
    static let shared = DatabaseEncryptionProvider()
    private let keychain = KeychainManager.shared
    private let keychainKey = "database_encryption_key"

    private init() {}

    func getKey() -> Data? {
        guard AppEnvironment.current == .production else { return nil }
        if let existing = try? keychain.load(forKey: keychainKey) { return existing }
        let newKey = CryptoProvider.shared.generateEncryptionKey()
        try? keychain.save(newKey, forKey: keychainKey)
        return newKey
    }
}
