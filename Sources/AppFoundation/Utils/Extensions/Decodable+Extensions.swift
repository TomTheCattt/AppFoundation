//
//  Decodable+Extensions.swift
//  AppFoundation
//
//  Decodable extensions for safe decoding.
//

import Foundation

extension Decodable {
    
    // MARK: - Basic Helpers
    
    /// Decodes from JSON data
    /// - Parameter data: JSON data
    /// - Returns: Decoded object
    /// - Throws: Decoding error
    static func decode(from data: Data) throws -> Self {
        return try JSONDecoder().decode(Self.self, from: data)
    }
    
    /// Decodes from a dictionary
    /// - Parameter dictionary: Dictionary to decode from
    /// - Returns: Decoded object
    /// - Throws: Decoding error
    static func decode(from dictionary: [String: Any]) throws -> Self {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        return try decode(from: data)
    }
    
    // MARK: - Advanced Helpers
    
    /// Safely decodes from data, returning nil on failure
    /// - Parameter data: JSON data
    /// - Returns: Decoded object or nil
    static func safelyDecode(from data: Data) -> Self? {
        return try? decode(from: data)
    }
    
    /// Decodes with custom decoder
    /// - Parameters:
    ///   - data: JSON data
    ///   - decoder: Custom JSON decoder
    /// - Returns: Decoded object
    /// - Throws: Decoding error
    static func decode(from data: Data, using decoder: JSONDecoder) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}
