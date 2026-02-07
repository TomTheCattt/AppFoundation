//
//  InfrastructureAssembly.swift
//  BaseIOSApp
//
//  Phase 5: Advanced caching, sync queue, background tasks, push notifications.
//

import Foundation
import Swinject

final class InfrastructureAssembly: Assembly {
    func assemble(container: Container) {
        // Layered cache (optional; use when persistence + speed needed)
        container.register(LayeredCache.self) { r in
            LayeredCache(
                memory: r.resolve(CacheProtocol.self)!,
                disk: DiskCache()
            )
        }

        // Pending sync queue
        container.register(PendingSyncQueueProtocol.self) { _ in
            UserDefaultsPendingSyncQueue()
        }.inObjectScope(.container)

        // Sync manager
        container.register(SyncManagerProtocol.self) { r in
            SyncManager(
                networkMonitor: r.resolve(NetworkMonitorProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }.inObjectScope(.container)

        // Background task manager
        container.register(BackgroundTaskManaging.self) { r in
            BackgroundTaskManager(logger: r.resolve(Logger.self)!)
        }.inObjectScope(.container)

        // Device token store
        container.register(DeviceTokenStoreProtocol.self) { _ in
            DeviceTokenStore()
        }.inObjectScope(.container)

        // Push notification service
        container.register(PushNotificationServiceProtocol.self) { r in
            PushNotificationService(
                deviceTokenStore: r.resolve(DeviceTokenStoreProtocol.self)!,
                logger: r.resolve(Logger.self)!
            )
        }.inObjectScope(.container)
    }
}
