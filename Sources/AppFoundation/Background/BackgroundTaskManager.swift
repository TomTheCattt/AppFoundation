//
//  BackgroundTaskManager.swift
//  AppFoundation
//
//  Wraps BGTaskScheduler for app refresh and optional processing tasks. iOS 13+.
//

import Foundation
import BackgroundTasks

enum BackgroundTaskIdentifier {
    static let appRefresh = "\(AppConstants.Security.keychainService).refresh"
    static let processing = "\(AppConstants.Security.keychainService).processing"
}

protocol BackgroundTaskManaging: AnyObject {
    func registerHandlers(refresh: @escaping (BGAppRefreshTask) -> Void, processing: ((BGProcessingTask) -> Void)?)
    func scheduleAppRefresh(earliestBeginDate: Date?)
    func scheduleProcessing(earliestBeginDate: Date?, requiresNetwork: Bool, requiresExternalPower: Bool)
}

final class BackgroundTaskManager: BackgroundTaskManaging {
    private let logger: Logger
    private var refreshHandler: ((BGAppRefreshTask) -> Void)?
    private var processingHandler: ((BGProcessingTask) -> Void)?

    init(logger: Logger) {
        self.logger = logger
    }

    func registerHandlers(
        refresh: @escaping (BGAppRefreshTask) -> Void,
        processing: ((BGProcessingTask) -> Void)? = nil
    ) {
        refreshHandler = refresh
        processingHandler = processing
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: BackgroundTaskIdentifier.appRefresh,
            using: nil
        ) { [weak self] task in
            self?.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        if processingHandler != nil {
            BGTaskScheduler.shared.register(
                forTaskWithIdentifier: BackgroundTaskIdentifier.processing,
                using: nil
            ) { [weak self] task in
                self?.handleProcessing(task: task as! BGProcessingTask)
            }
        }
        logger.info("BackgroundTaskManager: handlers registered")
    }

    func scheduleAppRefresh(earliestBeginDate: Date? = nil) {
        let request = BGAppRefreshTaskRequest(identifier: BackgroundTaskIdentifier.appRefresh)
        request.earliestBeginDate = earliestBeginDate ?? Date(timeIntervalSinceNow: 15 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
            logger.info("BackgroundTaskManager: app refresh scheduled")
        } catch {
            logger.error("BackgroundTaskManager: failed to schedule refresh \(error)")
        }
    }

    func scheduleProcessing(
        earliestBeginDate: Date? = nil,
        requiresNetwork: Bool = true,
        requiresExternalPower: Bool = false
    ) {
        let request = BGProcessingTaskRequest(identifier: BackgroundTaskIdentifier.processing)
        request.earliestBeginDate = earliestBeginDate ?? Date(timeIntervalSinceNow: 30 * 60)
        request.requiresNetworkConnectivity = requiresNetwork
        request.requiresExternalPower = requiresExternalPower
        do {
            try BGTaskScheduler.shared.submit(request)
            logger.info("BackgroundTaskManager: processing scheduled")
        } catch {
            logger.error("BackgroundTaskManager: failed to schedule processing \(error)")
        }
    }

    private func handleAppRefresh(task: BGAppRefreshTask) {
        refreshHandler?(task)
        task.expirationHandler = { [weak self] in
            self?.logger.warning("BackgroundTaskManager: app refresh expired")
            task.setTaskCompleted(success: false)
        }
    }

    private func handleProcessing(task: BGProcessingTask) {
        processingHandler?(task)
        task.expirationHandler = { [weak self] in
            self?.logger.warning("BackgroundTaskManager: processing expired")
            task.setTaskCompleted(success: false)
        }
    }
}
