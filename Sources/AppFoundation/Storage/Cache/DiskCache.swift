//
//  DiskCache.swift
//  AppFoundation
//

import Foundation

final class DiskCache: CacheProtocol {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    init() {
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("DiskCache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    func set<T: Encodable>(_ value: T, forKey key: String, expiration: TimeInterval? = nil) throws {
        let data = try JSONEncoder().encode(value)
        let fileURL = cacheDirectory.appendingPathComponent(key.safeFileName())
        try data.write(to: fileURL)
    }

    func get<T: Decodable>(forKey key: String) throws -> T? {
        let fileURL = cacheDirectory.appendingPathComponent(key.safeFileName())
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func remove(forKey key: String) throws {
        let fileURL = cacheDirectory.appendingPathComponent(key.safeFileName())
        try? fileManager.removeItem(at: fileURL)
    }

    func removeAll() throws {
        let contents = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
        contents?.forEach { try? fileManager.removeItem(at: $0) }
    }

    func exists(forKey key: String) -> Bool {
        let fileURL = cacheDirectory.appendingPathComponent(key.safeFileName())
        return fileManager.fileExists(atPath: fileURL.path)
    }
}

private extension String {
    func safeFileName() -> String {
        addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? self
    }
}
