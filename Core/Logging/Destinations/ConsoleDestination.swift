//
//  ConsoleDestination.swift
//  BaseIOSApp
//

import Foundation

final class ConsoleDestination: LogDestination {
    let minimumLogLevel: LogLevel
    private let formatter: LogFormatter

    init(minimumLogLevel: LogLevel = .debug, formatter: LogFormatter = DefaultLogFormatter()) {
        self.minimumLogLevel = minimumLogLevel
        self.formatter = formatter
    }

    func log(_ entry: LogEntry) {
        print(formatter.format(entry))
    }
}
