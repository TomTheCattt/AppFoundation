//
//  LogFormatter.swift
//  BaseIOSApp
//

import Foundation

public protocol LogFormatter {
    func format(_ entry: LogEntry) -> String
}

public struct DefaultLogFormatter: LogFormatter {
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return f
    }()

    public init() {}

    public func format(_ entry: LogEntry) -> String {
        let timestamp = dateFormatter.string(from: entry.timestamp)
        let fileName = (entry.file as NSString).lastPathComponent
        return "\(entry.level.emoji) [\(timestamp)] \(entry.level) - \(fileName):\(entry.line) - \(entry.function)\n\(entry.message)"
    }
}

public struct JSONLogFormatter: LogFormatter {
    public init() {}

    public func format(_ entry: LogEntry) -> String {
        let dict: [String: Any] = [
            "timestamp": ISO8601DateFormatter().string(from: entry.timestamp),
            "level": String(describing: entry.level),
            "message": entry.message,
            "file": entry.file,
            "function": entry.function,
            "line": entry.line
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: dict),
              let json = String(data: data, encoding: .utf8) else { return "" }
        return json
    }
}
