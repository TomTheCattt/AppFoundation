//
//  Dictionary+Extensions.swift
//  AppFoundation
//
//  Dictionary extensions for safe access and manipulation.
//

import Foundation

extension Dictionary {
    
    // MARK: - Basic Helpers
    
    /// Safe subscript access that returns nil instead of crashing
    /// - Parameter key: Dictionary key
    /// - Returns: Value if exists, nil otherwise
    subscript(safe key: Key) -> Value? {
        return self[key]
    }
    
    /// Merges another dictionary into this one
    /// - Parameter other: Dictionary to merge
    /// - Returns: Merged dictionary
    func merged(with other: [Key: Value]) -> [Key: Value] {
        var result = self
        other.forEach { result[$0.key] = $0.value }
        return result
    }
    
    // MARK: - Advanced Helpers
    
    /// Maps both keys and values
    /// - Parameter transform: Transform closure
    /// - Returns: Transformed dictionary
    func mapKeysAndValues<K: Hashable, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)) rethrows -> [K: V] {
        var result = [K: V]()
        for (key, value) in self {
            let (newKey, newValue) = try transform((key, value))
            result[newKey] = newValue
        }
        return result
    }
    
    /// Compact maps values, removing nil results
    /// - Parameter transform: Transform closure
    /// - Returns: Dictionary with transformed non-nil values
    func compactMapValues<T>(_ transform: (Value) throws -> T?) rethrows -> [Key: T] {
        var result = [Key: T]()
        for (key, value) in self {
            if let transformed = try transform(value) {
                result[key] = transformed
            }
        }
        return result
    }
}
