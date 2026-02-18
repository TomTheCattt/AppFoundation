//
//  Array+Extensions.swift
//  AppFoundation
//
//  Array extensions for safe access and transformations.
//

import Foundation

extension Array {
    
    // MARK: - Basic Helpers
    
    /// Safe subscript access that returns nil instead of crashing
    /// - Parameter index: Array index
    /// - Returns: Element if index is valid, nil otherwise
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    /// Chunks the array into smaller arrays of specified size
    /// - Parameter size: Size of each chunk
    /// - Returns: Array of chunks
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
    
    // MARK: - Advanced Helpers
    
    /// Asynchronously maps elements
    /// - Parameter transform: Async transformation closure
    /// - Returns: Transformed array
    func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        var results = [T]()
        for element in self {
            try await results.append(transform(element))
        }
        return results
    }
    
    /// Asynchronously compact maps elements
    /// - Parameter transform: Async transformation closure
    /// - Returns: Transformed array with nil values removed
    func asyncCompactMap<T>(_ transform: (Element) async throws -> T?) async rethrows -> [T] {
        var results = [T]()
        for element in self {
            if let transformed = try await transform(element) {
                results.append(transformed)
            }
        }
        return results
    }
}

extension Array where Element: Equatable {
    
    /// Removes the first occurrence of an element
    /// - Parameter element: Element to remove
    /// - Returns: True if element was found and removed
    @discardableResult
    mutating func remove(_ element: Element) -> Bool {
        if let index = firstIndex(of: element) {
            remove(at: index)
            return true
        }
        return false
    }
    
    /// Removes all occurrences of an element
    /// - Parameter element: Element to remove
    /// - Returns: Number of elements removed
    @discardableResult
    mutating func removeAll(_ element: Element) -> Int {
        let initialCount = count
        self = filter { $0 != element }
        return initialCount - count
    }
}
