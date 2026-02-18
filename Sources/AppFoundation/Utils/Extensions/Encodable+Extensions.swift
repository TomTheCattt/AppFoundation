//
//  Encodable+Extensions.swift
//  AppFoundation
//
//  Encodable extensions for JSON conversion.
//

import Foundation

extension Encodable {
    
    // MARK: - Basic Helpers
    
    /// Converts the encodable object to a dictionary
    /// - Returns: Dictionary representation
    /// - Throws: Encoding error
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw EncodingError.invalidValue(self, EncodingError.Context(
                codingPath: [],
                debugDescription: "Failed to convert to dictionary"
            ))
        }
        return dictionary
    }
    
    /// Converts the encodable object to JSON data
    /// - Returns: JSON data
    /// - Throws: Encoding error
    func asJSON() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    // MARK: - Advanced Helpers
    
    /// Converts the encodable object to a pretty-printed JSON string
    /// - Returns: Formatted JSON string
    /// - Throws: Encoding error
    func prettyJSON() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    /// Encodes with custom encoder options
    /// - Parameter encoder: Custom JSON encoder
    /// - Returns: Encoded data
    /// - Throws: Encoding error
    func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}
