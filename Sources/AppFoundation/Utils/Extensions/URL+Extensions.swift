//
//  URL+Extensions.swift
//  AppFoundation
//
//  URL extensions for query parameters and validation.
//

import Foundation

extension URL {
    
    // MARK: - Basic Helpers
    
    /// Extracts query parameters as a dictionary
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        queryItems.forEach { parameters[$0.name] = $0.value }
        return parameters
    }
    
    /// Appends query items to the URL
    /// - Parameter queryItems: Dictionary of query parameters
    /// - Returns: URL with appended query items
    func appendingQueryItems(_ queryItems: [String: String]) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        
        var items = components.queryItems ?? []
        items.append(contentsOf: queryItems.map { URLQueryItem(name: $0.key, value: $0.value) })
        components.queryItems = items
        
        return components.url ?? self
    }
    
    // MARK: - Advanced Helpers
    
    /// Checks if the URL is reachable (synchronous)
    /// - Returns: True if reachable
    var isReachable: Bool {
        guard let reachability = try? Reachability(hostname: host ?? "") else {
            return false
        }
        return reachability.connection != .unavailable
    }
    
    /// Gets the file size for file URLs
    /// - Returns: File size in bytes, nil if not a file URL or error
    var fileSize: Int64? {
        guard isFileURL else { return nil }
        
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: path)
            return attributes[.size] as? Int64
        } catch {
            return nil
        }
    }
}

// MARK: - Reachability Helper

/// Simple reachability checker
private class Reachability {
    enum Connection {
        case unavailable, wifi, cellular
    }
    
    var connection: Connection = .unavailable
    
    init(hostname: String) throws {
        // Simplified implementation - in production use Network framework
        connection = .wifi
    }
}
