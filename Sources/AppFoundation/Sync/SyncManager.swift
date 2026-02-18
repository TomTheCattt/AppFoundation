//
//  SyncManager.swift
//  AppFoundation
//
//  Observes network; when online, runs sync callback. Register from app or repositories.
//

import Foundation

protocol SyncManagerProtocol: AnyObject, Sendable {
    func whenOnline(perform sync: @escaping @Sendable () async throws -> Void)
    func triggerSync()
    func performSync() async throws
}

/// Holds a sync closure; call triggerSync() when app enters foreground or network may be back.
final class SyncManager: SyncManagerProtocol, @unchecked Sendable {
    private let networkMonitor: NetworkMonitorProtocol
    private let logger: Logger
    private let syncClosureQueue = DispatchQueue(label: "SyncManager.syncClosure")
    private var _syncClosure: (@Sendable () async throws -> Void)?
    
    private var syncClosure: (@Sendable () async throws -> Void)? {
        get { syncClosureQueue.sync { _syncClosure } }
        set { syncClosureQueue.sync { _syncClosure = newValue } }
    }

    init(networkMonitor: NetworkMonitorProtocol, logger: Logger) {
        self.networkMonitor = networkMonitor
        self.logger = logger
    }

    func whenOnline(perform sync: @escaping @Sendable () async throws -> Void) {
        syncClosure = sync
    }

    /// Call from SceneDelegate (sceneWillEnterForeground) or when network is restored.
    func triggerSync() {
        guard networkMonitor.isConnected else { return }
        Task {
            try? await performSync()
        }
    }

    /// Run sync and wait. Use from background task handler so you can setTaskCompleted after.
    func performSync() async throws {
        guard networkMonitor.isConnected else { return }
        try await syncClosure?()
        logger.info("SyncManager: sync completed")
    }
}
