//
//  Collection+Extensions.swift
//  BaseIOSApp
//
//  Collection extensions for common operations.
//

import Foundation

extension Collection {
    
    // MARK: - Basic Helpers
    
    /// Checks if the collection is not empty
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    /// Returns the second element if it exists
    var second: Element? {
        return self.count > 1 ? self[index(startIndex, offsetBy: 1)] : nil
    }
    
    /// Returns the third element if it exists
    var third: Element? {
        return self.count > 2 ? self[index(startIndex, offsetBy: 2)] : nil
    }
    
    // MARK: - Advanced Helpers
    
    /// Groups elements by a key
    /// - Parameter keyPath: Key path to group by
    /// - Returns: Dictionary grouped by key
    func grouped<Key: Hashable>(by keyPath: KeyPath<Element, Key>) -> [Key: [Element]] {
        return Dictionary(grouping: self, by: { $0[keyPath: keyPath] })
    }
}

extension Collection where Element: Hashable {
    
    /// Returns unique elements preserving order
    /// - Returns: Array of unique elements
    func unique() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

extension Collection where Element: Equatable {
    
    /// Returns unique elements by a specific key path
    /// - Parameter keyPath: Key path to determine uniqueness
    /// - Returns: Array of unique elements
    func unique<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}
