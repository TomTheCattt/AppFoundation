//
//  BaseRepository.swift
//  BaseIOSCore
//
//  Created by BaseIOSApp Package.
//

import Foundation

open class BaseRepository {
    public let apiClient: APIClient
    public let storage: PersistenceProtocol
    
    public init(apiClient: APIClient = APIClient(interceptors: []), storage: PersistenceProtocol = DiskStorage.shared) {
        self.apiClient = apiClient
        self.storage = storage
    }
    
    /// Fetch data with caching strategy
    /// - Parameters:
    ///   - endpoint: API Endpoint
    ///   - responseType: Type to decode
    ///   - strategy: Cache Strategy (default .networkFirst)
    public func fetch<T: Codable>(
        endpoint: Endpoint,
        responseType: T.Type,
        strategy: CacheStrategy = .networkFirst
    ) async throws -> T {
        
        let cacheKey = cacheKeyFor(endpoint)
        
        switch strategy {
        case .networkOnly:
            return try await apiClient.request(endpoint, responseType: T.self)
            
        case .cacheOnly:
            if let data = try storage.load(for: cacheKey) {
                return try JSONDecoder().decode(T.self, from: data)
            } else {
                throw NetworkError.notFound(apiCode: "CACHE_MISS")
            }
            
        case .networkFirst:
            do {
                let result = try await apiClient.request(endpoint, responseType: T.self)
                // Save to cache
                saveToCache(result, key: cacheKey)
                return result
            } catch {
                // Network failed, try cache
                if let data = try storage.load(for: cacheKey) {
                    return try JSONDecoder().decode(T.self, from: data)
                }
                throw error // No cache, throw original error
            }
            
        case .cacheFirst:
            // This is complex for async/await return type as it implies a stream (Cache -> then Network).
            // For simple async method, 'cacheFirst' usually means: Check cache, if missing, go network.
            if let data = try storage.load(for: cacheKey) {
                return try JSONDecoder().decode(T.self, from: data)
            }
            let result = try await apiClient.request(endpoint, responseType: T.self)
            saveToCache(result, key: cacheKey)
            return result
        }
    }
    
    private func cacheKeyFor(_ endpoint: Endpoint) -> String {
        return endpoint.path + (endpoint.queryParameters?.description ?? "")
    }
    
    private func saveToCache<T: Codable>(_ object: T, key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            try storage.save(data, for: key)
        } catch {
            Logger.shared.error("Failed to cache data: \(error)")
        }
    }
}
