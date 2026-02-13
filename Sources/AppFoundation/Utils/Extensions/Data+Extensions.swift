//
//  Data+Extensions.swift
//  AppFoundation
//
//  Data extensions for conversions and formatting.
//

import Foundation

extension Data {
    
    // MARK: - Basic Helpers
    
    /// Converts data to hex string
    /// - Returns: Hex string representation
    func toHexString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// Converts data to JSON object
    /// - Returns: JSON object (dictionary or array)
    /// - Throws: JSONSerialization error
    func toJSON() throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: [])
    }
    
    // MARK: - Advanced Helpers
    
    /// Converts data to pretty-printed JSON string
    /// - Returns: Formatted JSON string
    func prettyPrintedJSON() -> String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyString = String(data: data, encoding: .utf8) else {
            return nil
        }
        return prettyString
    }
    
    /// Converts data to base64 URL-safe encoded string
    /// - Returns: Base64 URL-safe string
    func base64URLEncoded() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
