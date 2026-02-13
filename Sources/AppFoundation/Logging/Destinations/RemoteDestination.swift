//
//  RemoteDestination.swift
//  AppFoundation
//
//  Send logs to remote (e.g. Crashlytics). Phase 1 stub.
//

import Foundation

final class RemoteDestination: LogDestination {
    let minimumLogLevel: LogLevel
    private let formatter: LogFormatter

    init(minimumLogLevel: LogLevel = .error, formatter: LogFormatter = JSONLogFormatter()) {
        self.minimumLogLevel = minimumLogLevel
        self.formatter = formatter
    }

    func log(_ entry: LogEntry) {
        let _ = formatter.format(entry)
        // TODO: Send to remote (Firebase, Sentry) when integrated
    }
}
