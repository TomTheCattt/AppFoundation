//
//  SecureStorageProtocol.swift
//  AppFoundation
//

import Foundation

protocol SecureStorageProtocol {
    func saveSecurely<T: Encodable>(_ value: T, forKey key: String) throws
    func loadSecurely<T: Decodable>(forKey key: String) throws -> T?
    func deleteSecurely(forKey key: String) throws
}

final class SecureStorage: SecureStorageProtocol {
    private let keychain = KeychainManager.shared
    private let crypto = CryptoProvider.shared
    private let keychainKey = "secure_storage_encryption_key"

    private func getOrCreateEncryptionKey() throws -> Data {
        if let existing = try? keychain.load(forKey: keychainKey) { return existing }
        let newKey = crypto.generateEncryptionKey()
        try keychain.save(newKey, forKey: keychainKey)
        return newKey
    }

    func saveSecurely<T: Encodable>(_ value: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(value)
        let encryptionKey = try getOrCreateEncryptionKey()
        let encrypted = try crypto.encrypt(data, key: encryptionKey)
        try keychain.save(encrypted, forKey: key)
    }

    func loadSecurely<T: Decodable>(forKey key: String) throws -> T? {
        let encrypted = try? keychain.load(forKey: key)
        guard let encrypted = encrypted else { return nil }
        let encryptionKey = try getOrCreateEncryptionKey()
        let data = try crypto.decrypt(encrypted, key: encryptionKey)
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func deleteSecurely(forKey key: String) throws {
        try keychain.delete(forKey: key)
    }
}
