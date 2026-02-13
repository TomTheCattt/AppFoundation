//
//  MemoryCache.swift
//  AppFoundation
//

import Foundation

private struct CacheEntry {
    let data: Data
    let expirationDate: Date?
}

final class MemoryCache: CacheProtocol {
    private var storage: [String: CacheEntry] = [:]
    private let queue = DispatchQueue(label: "MemoryCache", attributes: .concurrent)
    private let maxSize: Int

    init(maxSize: Int = AppConstants.Storage.cacheSize) {
        self.maxSize = maxSize
    }

    func set<T: Encodable>(_ value: T, forKey key: String, expiration: TimeInterval? = nil) throws {
        let data = try JSONEncoder().encode(value)
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            let exp = expiration.map { Date().addingTimeInterval($0) }
            self.storage[key] = CacheEntry(data: data, expirationDate: exp)
        }
    }

    func get<T: Decodable>(forKey key: String) throws -> T? {
        queue.sync {
            guard let entry = storage[key] else { return nil }
            if let exp = entry.expirationDate, exp < Date() {
                storage.removeValue(forKey: key)
                return nil
            }
            return try? JSONDecoder().decode(T.self, from: entry.data)
        }
    }

    func remove(forKey key: String) throws {
        queue.async(flags: .barrier) { [weak self] in
            self?.storage.removeValue(forKey: key)
        }
    }

    func removeAll() throws {
        queue.async(flags: .barrier) { [weak self] in
            self?.storage.removeAll()
        }
    }

    func exists(forKey key: String) -> Bool {
        queue.sync {
            guard let entry = storage[key] else { return false }
            if let exp = entry.expirationDate, exp < Date() {
                storage.removeValue(forKey: key)
                return false
            }
            return true
        }
    }
}
