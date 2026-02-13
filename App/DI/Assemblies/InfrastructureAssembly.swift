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
        container.register(LayeredCache.self) { register in
            LayeredCache(
                memory: register.resolve(CacheProtocol.self)!,
                disk: DiskCache()
            )
        }

        // Pending sync queue
        container.register(PendingSyncQueueProtocol.self) { _ in
            UserDefaultsPendingSyncQueue()
        }.inObjectScope(.container)

        // Sync manager
        container.register(SyncManagerProtocol.self) { register in
            SyncManager(
                networkMonitor: register.resolve(NetworkMonitorProtocol.self)!,
                logger: register.resolve(Logger.self)!
            )
        }.inObjectScope(.container)

        // Background task manager
        container.register(BackgroundTaskManaging.self) { register in
            BackgroundTaskManager(logger: register.resolve(Logger.self)!)
        }.inObjectScope(.container)

        // Device token store
        container.register(DeviceTokenStoreProtocol.self) { _ in
            DeviceTokenStore()
        }.inObjectScope(.container)

        // Push notification service
        container.register(PushNotificationServiceProtocol.self) { register in
            PushNotificationService(
                deviceTokenStore: register.resolve(DeviceTokenStoreProtocol.self)!,
                logger: register.resolve(Logger.self)!
            )
        }.inObjectScope(.container)
    }
}
