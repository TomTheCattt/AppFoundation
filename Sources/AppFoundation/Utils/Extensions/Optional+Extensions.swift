//
//  Optional+Extensions.swift
//  AppFoundation
//
//  Optional extensions for unwrapping and transformations.
//

import Foundation

extension Optional {
    
    // MARK: - Basic Helpers
    
    /// Unwraps the optional or returns a default value
    /// - Parameter defaultValue: Default value if nil
    /// - Returns: Unwrapped value or default
    func unwrap(or defaultValue: Wrapped) -> Wrapped {
        return self ?? defaultValue
    }
    
    /// Checks if optional is nil
    var isNil: Bool {
        return self == nil
    }
    
    /// Checks if optional has a value
    var hasValue: Bool {
        return self != nil
    }
    
    // MARK: - Advanced Helpers
    
    /// Applies a function to the wrapped value if it exists
    /// - Parameter transform: Function to apply
    /// - Returns: Transformed optional
    func apply<T>(_ transform: (Wrapped) -> T) -> T? {
        return self.map(transform)
    }
    
    /// Throws an error if the optional is nil
    /// - Parameter error: Error to throw
    /// - Returns: Unwrapped value
    /// - Throws: The provided error if nil
    func unwrap(or error: Error) throws -> Wrapped {
        guard let value = self else {
            throw error
        }
        return value
    }
}

extension Optional where Wrapped == String {
    
    /// Checks if the optional string is nil or empty
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

extension Optional where Wrapped: Collection {
    
    /// Checks if the optional collection is nil or empty
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
