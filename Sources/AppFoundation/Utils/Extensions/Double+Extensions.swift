//
//  Double+Extensions.swift
//  AppFoundation
//
//  Double extensions for rounding and formatting.
//

import Foundation

extension Double {
    
    // MARK: - Basic Helpers
    
    /// Rounds to a specific number of decimal places
    /// - Parameter places: Number of decimal places
    /// - Returns: Rounded value
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// Formats as currency
    /// - Parameters:
    ///   - currencyCode: Currency code (default: "USD")
    ///   - locale: Locale (default: current)
    /// - Returns: Formatted currency string
    func asCurrency(currencyCode: String = "USD", locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = locale
        return formatter.string(from: NSNumber(value: self)) ?? "$\(self)"
    }
    
    // MARK: - Advanced Helpers
    
    /// Formats as percentage
    /// - Parameter decimals: Number of decimal places (default: 0)
    /// - Returns: Formatted percentage string
    func asPercentage(decimals: Int = 0) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)%"
    }
    
    /// Converts degrees to radians
    var toRadians: Double {
        return self * .pi / 180.0
    }
    
    /// Converts radians to degrees
    var toDegrees: Double {
        return self * 180.0 / .pi
    }
}
