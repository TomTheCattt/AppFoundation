//
//  LayeredCache.swift
//  AppFoundation
//
//  L1: memory (fast), L2: disk (persistent). Read: memory then disk. Write: both.
//

import Foundation

/// Two-tier cache: memory first, then disk. Use for data that should survive app restart but benefit from fast reads.
final class LayeredCache: CacheProtocol {
    private let memory: CacheProtocol
    private let disk: CacheProtocol

    init(memory: CacheProtocol, disk: CacheProtocol) {
        self.memory = memory
        self.disk = disk
    }

    func set<T: Encodable>(_ value: T, forKey key: String, expiration: TimeInterval? = nil) throws {
        try memory.set(value, forKey: key, expiration: expiration)
        try? disk.set(value, forKey: key, expiration: nil)
    }

    func get<T: Decodable>(forKey key: String) throws -> T? {
        if let value: T = try memory.get(forKey: key) { return value }
        return try disk.get(forKey: key)
    }

    func remove(forKey key: String) throws {
        try? memory.remove(forKey: key)
        try? disk.remove(forKey: key)
    }

    func removeAll() throws {
        try? memory.removeAll()
        try? disk.removeAll()
    }

    func exists(forKey key: String) -> Bool {
        memory.exists(forKey: key) || disk.exists(forKey: key)
    }
}
