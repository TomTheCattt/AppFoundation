//
//  CryptoProvider.swift
//  AppFoundation
//

import CryptoKit
import Foundation

final class CryptoProvider {
    static let shared = CryptoProvider()

    private init() {}

    func generateEncryptionKey() -> Data {
        SymmetricKey(size: .bits256).withUnsafeBytes { Data($0) }
    }

    func encrypt(_ data: Data, key: Data) throws -> Data {
        let symmetricKey = SymmetricKey(data: key)
        let sealedBox = try AES.GCM.seal(data, using: symmetricKey)
        return sealedBox.combined ?? data
    }

    func decrypt(_ data: Data, key: Data) throws -> Data {
        let symmetricKey = SymmetricKey(data: key)
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        return try AES.GCM.open(sealedBox, using: symmetricKey)
    }

    func hash(_ string: String) -> String {
        let data = Data(string.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
