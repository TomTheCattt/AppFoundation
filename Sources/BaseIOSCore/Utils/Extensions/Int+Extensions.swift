//
//  Int+Extensions.swift
//  BaseIOSApp
//
//  Int extensions for formatting and conversions.
//

import Foundation

extension Int {
    
    // MARK: - Basic Helpers
    
    /// Formats the integer with a specific style
    /// - Parameter style: Number formatter style
    /// - Returns: Formatted string
    func formatted(style: NumberFormatter.Style = .decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    /// Checks if the number is even
    var isEven: Bool {
        return self % 2 == 0
    }
    
    /// Checks if the number is odd
    var isOdd: Bool {
        return !isEven
    }
    
    // MARK: - Advanced Helpers
    
    /// Returns the ordinal representation (1st, 2nd, 3rd, etc.)
    var ordinal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    /// Converts to Roman numerals (1-3999)
    var toRoman: String? {
        guard self > 0 && self < 4000 else { return nil }
        
        let romanValues = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
                          (100, "C"), (90, "XC"), (50, "L"), (40, "XL"),
                          (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]
        
        var result = ""
        var number = self
        
        for (value, numeral) in romanValues {
            while number >= value {
                result += numeral
                number -= value
            }
        }
        
        return result
    }
    
    /// Returns abbreviated form (1000 → "1K", 1000000 → "1M")
    var abbreviated: String {
        let absNumber = abs(self)
        let sign = self < 0 ? "-" : ""
        
        switch absNumber {
        case 1_000_000_000...:
            return "\(sign)\(absNumber / 1_000_000_000)B"
        case 1_000_000...:
            return "\(sign)\(absNumber / 1_000_000)M"
        case 1_000...:
            return "\(sign)\(absNumber / 1_000)K"
        default:
            return "\(sign)\(absNumber)"
        }
    }
}
