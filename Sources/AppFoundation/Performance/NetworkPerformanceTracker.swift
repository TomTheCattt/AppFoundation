//
//  NetworkPerformanceTracker.swift
//  AppFoundation
//

import Foundation

final class NetworkPerformanceTracker {
    private var metrics: [String: [TimeInterval]] = [:]
    private let queue = DispatchQueue(label: "NetworkPerformanceTracker")

    func track(endpoint: String, duration: TimeInterval) {
        queue.async {
            self.metrics[endpoint, default: []].append(duration)
            if (self.metrics[endpoint]?.count ?? 0) > 100 {
                self.metrics[endpoint]?.removeFirst()
            }
            let avg = (self.metrics[endpoint] ?? []).reduce(0, +) / Double(max(1, self.metrics[endpoint]?.count ?? 0))
            if avg > 2.0 {
                Logger.shared.warning("Slow endpoint: \(endpoint) avg: \(avg)s")
            }
        }
    }

    func report() -> [String: TimeInterval] {
        queue.sync {
            metrics.mapValues { $0.reduce(0, +) / Double(max(1, $0.count)) }
        }
    }
}
