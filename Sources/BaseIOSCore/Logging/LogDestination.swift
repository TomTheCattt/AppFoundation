//
//  LogDestination.swift
//  BaseIOSApp
//

import Foundation

public protocol LogDestination {
    var minimumLogLevel: LogLevel { get }
    func log(_ entry: LogEntry)
    func shouldLog(level: LogLevel) -> Bool
}

public extension LogDestination {
    func shouldLog(level: LogLevel) -> Bool {
        level >= minimumLogLevel
    }
}
