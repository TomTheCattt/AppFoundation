//
//  SyncMocks.swift
//  BaseIOSAppTests
//

import Foundation
@testable import BaseIOSApp

// MARK: - Mock NetworkMonitor (for SyncManager tests)

final class MockNetworkMonitor: NetworkMonitorProtocol {
    var isConnected: Bool = true
}
