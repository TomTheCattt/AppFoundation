//
//  AppBootstrapper.swift
//  BaseIOSApp
//
//  Single entry point for app initialization. Must be called exactly once in didFinishLaunching.
//

import Foundation

final class AppBootstrapper {
    static func bootstrap() {
        // 0. Reset state if needed (UITest)
        resetStateIfNeeded()
        // 1. Logger first
        setupLogger()
        // 2. Environment
        setupEnvironment()
        // 3. DI
        setupDependencies()
        // 4. Database
        setupDatabase()
        // 5. Networking
        setupNetworking()
        // 6. Security
        setupSecurity()
        // 7. Performance
        setupPerformanceMonitoring()
        // 8. Mock server when needed
        setupMockServerIfNeeded()
        // 9. Phase 5: Background tasks, push, sync
        // 9. Phase 5: Background tasks, push, sync
        if !ProcessInfo.processInfo.arguments.contains("--uitesting") {
            setupBackgroundTasks()
            setupPushNotifications()
        }
    }

    private static func resetStateIfNeeded() {
        if ProcessInfo.processInfo.arguments.contains("RESET_STATE") {
            // Clear Keychain
            try? KeychainManager.shared.delete(forKey: "auth_access_token")
            try? KeychainManager.shared.delete(forKey: "auth_refresh_token")
            // Clear UserDefaults
            if let bundleID = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
            }
        }
    }

    private static func setupLogger() {
        if AppEnvironment.current != .production {
            Logger.shared.addDestination(ConsoleDestination())
        }
        Logger.shared.addDestination(FileDestination())
        Logger.shared.info("Logger initialized")
    }

    private static func setupEnvironment() {
        Logger.shared.info("Environment: \(AppEnvironment.current)")
    }

    private static func setupDependencies() {
        DIAssembler.assemble(container: DIContainer.shared.container)
        Logger.shared.info("DI container assembled")
    }

    private static func setupDatabase() {
        _ = DIContainer.shared.resolve(LocalDatabaseProtocol.self)
        Logger.shared.info("Database initialized")
    }

    private static func setupNetworking() {
        _ = DIContainer.shared.resolve(APIClient.self)
        Logger.shared.info("Networking configured")
    }

    private static func setupSecurity() {
        _ = KeychainManager.shared
        Logger.shared.info("Security setup complete")
    }

    private static func setupPerformanceMonitoring() {
        PerformanceMonitor.shared.startMonitoring()
        Logger.shared.info("Performance monitoring started")
    }

    private static func setupMockServerIfNeeded() {
        guard AppEnvironment.current == .mock else { return }
        MockServerManager.shared.register(path: "/users", jsonFileName: "user_response")
        MockServerManager.shared.register(path: "/error", jsonFileName: "error_response")
        Logger.shared.info("Mock server enabled")
    }

    private static func setupBackgroundTasks() {
        let manager: BackgroundTaskManaging = DIContainer.shared.resolve(BackgroundTaskManaging.self)
        let syncManager: SyncManagerProtocol = DIContainer.shared.resolve(SyncManagerProtocol.self)
        manager.registerHandlers(
            refresh: { task in
                Task {
                    do {
                        try await syncManager.performSync()
                        task.setTaskCompleted(success: true)
                    } catch {
                        Logger.shared.error("Background sync failed: \(error)")
                        task.setTaskCompleted(success: false)
                    }
                }
            },
            processing: nil
        )
        Logger.shared.info("Background task handlers registered")
    }

    private static func setupPushNotifications() {
        let pushService: PushNotificationServiceProtocol = DIContainer.shared.resolve(PushNotificationServiceProtocol.self)
        pushService.registerForRemoteNotifications()
        Logger.shared.info("Push notification registration requested")
    }
}
