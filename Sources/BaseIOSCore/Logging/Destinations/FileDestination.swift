//
//  FileDestination.swift
//  BaseIOSApp
//

import Foundation

final class FileDestination: LogDestination {
    let minimumLogLevel: LogLevel
    private let formatter: LogFormatter
    private let fileManager = FileManager.default
    private let logFileURL: URL
    private let maxFileSize = 5 * 1024 * 1024 // 5MB
    private let queue = DispatchQueue(label: "FileDestination")

    init(minimumLogLevel: LogLevel = .info, formatter: LogFormatter = DefaultLogFormatter()) {
        self.minimumLogLevel = minimumLogLevel
        self.formatter = formatter
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.logFileURL = documentsURL.appendingPathComponent("Logs").appendingPathComponent("app.log")
        createLogFileIfNeeded()
    }

    func log(_ entry: LogEntry) {
        queue.async { [weak self] in
            guard let self = self else { return }
            let formatted = self.formatter.format(entry) + "\n"
            guard let data = formatted.data(using: .utf8) else { return }
            self.rotateLogFileIfNeeded()
            if let handle = try? FileHandle(forWritingTo: self.logFileURL) {
                handle.seekToEndOfFile()
                handle.write(data)
                try? handle.close()
            }
        }
    }

    private func rotateLogFileIfNeeded() {
        guard let attrs = try? fileManager.attributesOfItem(atPath: logFileURL.path),
              let size = attrs[.size] as? Int, size > maxFileSize else { return }
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let archived = logFileURL.deletingLastPathComponent().appendingPathComponent("app_\(timestamp).log")
        try? fileManager.moveItem(at: logFileURL, to: archived)
        createLogFileIfNeeded()
    }

    private func createLogFileIfNeeded() {
        let dir = logFileURL.deletingLastPathComponent()
        try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        if !fileManager.fileExists(atPath: logFileURL.path) {
            fileManager.createFile(atPath: logFileURL.path, contents: nil)
        }
    }
}
