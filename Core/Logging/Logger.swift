//
//  Logger.swift
//  BaseIOSApp
//
//  Centralized logging, multi-destination, log level filtering.
//

import Foundation

struct LogEntry {
    let message: String
    let level: LogLevel
    let timestamp: Date
    let file: String
    let function: String
    let line: Int
}

final class Logger {
    static let shared = Logger()
    private var destinations: [LogDestination] = []
    private let queue = DispatchQueue(label: "Logger", qos: .utility)

    private init() {}

    func addDestination(_ destination: LogDestination) {
        destinations.append(destination)
    }

    func log(
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

    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }

    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }

    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }

    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }
}
