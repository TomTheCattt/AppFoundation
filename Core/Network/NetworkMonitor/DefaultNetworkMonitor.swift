//
//  DefaultNetworkMonitor.swift
//  BaseIOSApp
//
//  Uses NWPathMonitor on supported platforms; falls back to assumed connected.
//

import Foundation
#if canImport(Network)
import Network
#endif

final class DefaultNetworkMonitor: NetworkMonitorProtocol {
    static let shared = DefaultNetworkMonitor()

#if canImport(Network)
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let lock = NSLock()
    private var _isConnected: Bool = true

    var isConnected: Bool {
        lock.lock()
        defer { lock.unlock() }
        return _isConnected
    }

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.lock.lock()
            self._isConnected = path.status == .satisfied
            self.lock.unlock()
        }
        monitor.start(queue: queue)
    }
#else
    var isConnected: Bool { true }
    private init() {}
#endif
}
