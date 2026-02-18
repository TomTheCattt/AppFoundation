//
//  Date+Extensions.swift
//  AppFoundation
//
//  Date extensions for formatting and comparisons.
//

import Foundation

extension Date {
    
    // MARK: - Basic Helpers
    
    /// Checks if the date is today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Checks if the date is in the past
    var isPast: Bool {
        return self < Date()
    }
    
    /// Checks if the date is in the future
    var isFuture: Bool {
        return self > Date()
    }
    
    /// Returns the start of the day
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// Returns the end of the day
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
    
    /// Adds days to the date
    /// - Parameter days: Number of days to add
    /// - Returns: New date
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    /// Formats the date with a specific style
    /// - Parameter style: Date formatter style
    /// - Returns: Formatted date string
    func formatted(style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
    // MARK: - Advanced Helpers
    
    /// Returns the age in years from this date to now
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
    
    /// Returns a human-readable "time ago" string
    var timeAgo: String {
        let components = Calendar.current.dateComponents(
            [.year, .month, .weekOfYear, .day, .hour, .minute, .second],
            from: self,
            to: Date()
        )
        
        if let years = components.year, years > 0 {
            return "\(years) year\(years == 1 ? "" : "s") ago"
        }
        if let months = components.month, months > 0 {
            return "\(months) month\(months == 1 ? "" : "s") ago"
        }
        if let weeks = components.weekOfYear, weeks > 0 {
            return "\(weeks) week\(weeks == 1 ? "" : "s") ago"
        }
        if let days = components.day, days > 0 {
            return "\(days) day\(days == 1 ? "" : "s") ago"
        }
        if let hours = components.hour, hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        }
        if let minutes = components.minute, minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        }
        if let seconds = components.second, seconds > 0 {
            return "\(seconds) second\(seconds == 1 ? "" : "s") ago"
        }
        return "just now"
    }
    
    /// ISO8601 formatted string
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
    
    /// Custom formatted string
    /// - Parameter format: Date format string (e.g., "yyyy-MM-dd HH:mm:ss")
    /// - Returns: Formatted string
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
