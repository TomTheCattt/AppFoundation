//
//  NetworkMonitor.swift
//  AppFoundation
//
//  Created by AppFoundation Package.
//

import Foundation
import Network

/// Monitors network connectivity status using Apple's Network framework
public final class NetworkMonitor {
    
    // MARK: - Singleton
    public static let shared = NetworkMonitor()
    
    // MARK: - Properties
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "com.appfoundation.networkmonitor")
    
    /// Current network connectivity status
    public private(set) var isConnected: Bool = true
    
    /// Current network connection type
    public private(set) var connectionType: ConnectionType = .unknown
    
    /// Callback when network status changes
    public var onStatusChange: ((Bool) -> Void)?
    
    // MARK: - Connection Types
    public enum ConnectionType {
        case wifi
        case cellular
        case wiredEthernet
        case unknown
    }
    
    // MARK: - Initialization
    private init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    // MARK: - Public Methods
    
    /// Start monitoring network connectivity
    public func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let wasConnected = self.isConnected
            self.isConnected = path.status == .satisfied
            self.connectionType = self.getConnectionType(from: path)
            
            // Notify only if status changed
            if wasConnected != self.isConnected {
                DispatchQueue.main.async {
                    self.onStatusChange?(self.isConnected)
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    /// Stop monitoring network connectivity
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    // MARK: - Private Methods
    
    private func getConnectionType(from path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .wiredEthernet
        } else {
            return .unknown
        }
    }
}
