//
//  ConsoleDestination.swift
//  BaseIOSApp
//

import Foundation

public final class ConsoleDestination: LogDestination {
    public let minimumLogLevel: LogLevel
    private let formatter: LogFormatter

    public init(minimumLogLevel: LogLevel = .debug, formatter: LogFormatter = DefaultLogFormatter()) {
        self.minimumLogLevel = minimumLogLevel
        self.formatter = formatter
    }

    public func log(_ entry: LogEntry) {
        print(formatter.format(entry))
    }
}
