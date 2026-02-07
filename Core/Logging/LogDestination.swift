//
//  LogDestination.swift
//  BaseIOSApp
//

import Foundation

protocol LogDestination {
    var minimumLogLevel: LogLevel { get }
    func log(_ entry: LogEntry)
    func shouldLog(level: LogLevel) -> Bool
}

extension LogDestination {
    func shouldLog(level: LogLevel) -> Bool {
        level >= minimumLogLevel
    }
}
