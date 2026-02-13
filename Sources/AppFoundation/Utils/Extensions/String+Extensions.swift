//
//  String+Extensions.swift
//  AppFoundation
//
//  String extensions for validation and transformations.
//

import Foundation
import UIKit

extension String {
    
    // MARK: - Basic Helpers
    
    /// Checks if the string is not empty
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    /// Returns the trimmed string (whitespace and newlines removed)
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Validates email format
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    /// Converts string to URL
    var asURL: URL? {
        return URL(string: self)
    }
    
    /// Returns localized string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Capitalizes the first letter
    var capitalizingFirstLetter: String {
        return prefix(1).capitalized + dropFirst()
    }
    
    // MARK: - Advanced Helpers
    
    /// Checks if string matches a regex pattern
    /// - Parameter regex: Regular expression pattern
    /// - Returns: True if matches
    func matches(regex: String) -> Bool {
        return range(of: regex, options: .regularExpression) != nil
    }
    
    /// Returns attributed string with specified attributes
    /// - Parameter attributes: Text attributes
    /// - Returns: NSAttributedString
    func attributed(with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    /// Truncates string to specified length with trailing text
    /// - Parameters:
    ///   - length: Maximum length
    ///   - trailing: Trailing text (default: "...")
    /// - Returns: Truncated string
    func truncated(to length: Int, trailing: String = "...") -> String {
        guard count > length else { return self }
        return prefix(length) + trailing
    }
    
    /// Converts HTML string to attributed string
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        return try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                     .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )
    }
    
    /// Removes HTML tags from string
    var removingHTMLTags: String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
