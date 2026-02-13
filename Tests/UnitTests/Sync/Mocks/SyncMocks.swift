//
//  SyncMocks.swift
//  AppFoundationTests
//

import Foundation
@testable import AppFoundation

// MARK: - Mock NetworkMonitor (for SyncManager tests)

final class MockNetworkMonitor: NetworkMonitorProtocol {
    var isConnected: Bool = true
}
