import Foundation

/// Strategies for caching data
public enum CacheStrategy {
    case networkOnly        // Always fetch from network, do not save to cache
    case networkFirst       // Try network, if fails, fallback to cache
    case cacheFirst         // Return cache immediately (if exists), then fetch network (optional update)
    case cacheOnly          // Only load from cache (Offline mode)
}

/// Base protocol for raw data persistence
public protocol PersistenceProtocol {
    func save(_ data: Data, for key: String) throws
    func load(for key: String) throws -> Data?
    func delete(for key: String) throws
    func clear() throws
}

/// Generic protocol for Codable object storage
public protocol StorageProtocol {
    func save<T: Codable>(_ object: T, for key: String) throws
    func fetch<T: Codable>(for key: String) throws -> T?
    func delete(for key: String) throws
}
