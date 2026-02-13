//
//  DeviceTokenStore.swift
//  BaseIOSApp
//
//  Persists APNs device token (e.g. for backend registration). Uses Keychain.
//

import Foundation

protocol DeviceTokenStoreProtocol: AnyObject {
    var deviceToken: String? { get }
    func save(_ token: String) throws
    func clear() throws
}

private let deviceTokenKey = "apns_device_token"

final class DeviceTokenStore: DeviceTokenStoreProtocol {
    private let keychain: KeychainManager
    private let lock = NSLock()
    private var _cached: String?

    var deviceToken: String? {
        lock.lock()
        defer { lock.unlock() }
        if _cached == nil {
            _cached = (try? keychain.load(forKey: deviceTokenKey))
                .flatMap { String(data: $0, encoding: .utf8) }
        }
        return _cached
    }

    init(keychain: KeychainManager = .shared) {
        self.keychain = keychain
    }

    func save(_ token: String) throws {
        lock.lock()
        defer { lock.unlock() }
        guard let data = token.data(using: .utf8) else { return }
        try keychain.save(data, forKey: deviceTokenKey)
        _cached = token
    }

    func clear() throws {
        lock.lock()
        defer { lock.unlock() }
        try? keychain.delete(forKey: deviceTokenKey)
        _cached = nil
    }
}
