//
//  PerformanceMonitor.swift
//  BaseIOSApp
//

import Foundation
import UIKit

final class PerformanceMonitor {
    static let shared = PerformanceMonitor()
    private let memoryTracker = MemoryTracker()
    private let networkTracker = NetworkPerformanceTracker()

    private init() {}

    func startMonitoring() {
        memoryTracker.startTracking()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }

    @objc private func handleMemoryWarning() {
        Logger.shared.warning("Memory warning received")
        Logger.shared.warning("Current memory usage: \(memoryTracker.currentUsage())MB")
    }

    func measure<T>(_ operation: String, execute: () throws -> T) rethrows -> T {
        let start = CFAbsoluteTimeGetCurrent()
        defer {
            let duration = CFAbsoluteTimeGetCurrent() - start
            if duration > 0.5 {
                Logger.shared.warning("Slow operation: \(operation) took \(duration)s")
            }
        }
        return try execute()
    }

    func measureAsync<T>(_ operation: String, execute: () async throws -> T) async rethrows -> T {
        let start = CFAbsoluteTimeGetCurrent()
        defer {
            let duration = CFAbsoluteTimeGetCurrent() - start
            if duration > 0.5 {
                Logger.shared.warning("Slow async operation: \(operation) took \(duration)s")
            }
        }
        return try await execute()
    }
}
