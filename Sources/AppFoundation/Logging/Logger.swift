//
//  Logger.swift
//  AppFoundation
//
//  Centralized logging, multi-destination, log level filtering.
//

import Foundation

public struct LogEntry {
    public let message: String
    public let level: LogLevel
    public let timestamp: Date
    public let file: String
    public let function: String
    public let line: Int
    
    public init(message: String, level: LogLevel, timestamp: Date, file: String, function: String, line: Int) {
        self.message = message
        self.level = level
        self.timestamp = timestamp
        self.file = file
        self.function = function
        self.line = line
    }
}

public final class Logger {
    public static let shared = Logger()
    private var destinations: [LogDestination] = []
    private let queue = DispatchQueue(label: "Logger", qos: .utility)

    private init() {}

    public func addDestination(_ destination: LogDestination) {
        destinations.append(destination)
    }

    public func log(
        _ message: String,
        level: LogLevel,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let entry = LogEntry(
            message: message,
            level: level,
            timestamp: Date(),
            file: file,
            function: function,
            line: line
        )
        queue.async { [weak self] in
            self?.destinations.forEach { destination in
                if destination.shouldLog(level: level) {
                    destination.log(entry)
                }
            }
        }
    }

    public func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }

    public func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }

    public func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }

    public func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }
}
