//
//  PushNotificationService.swift
//  BaseIOSApp
//
//  Registers for remote notifications and stores device token. Handle presentation in AppDelegate/SceneDelegate.
//

import Foundation
import UIKit
import UserNotifications

protocol PushNotificationServiceProtocol: AnyObject {
    func registerForRemoteNotifications()
    func didRegister(deviceToken: Data)
    func didFailToRegister(error: Error)
}

/// Registers for push and stores token. Call registerForRemoteNotifications() after bootstrap.
final class PushNotificationService: PushNotificationServiceProtocol {
    private let deviceTokenStore: DeviceTokenStoreProtocol
    private let logger: Logger

    init(deviceTokenStore: DeviceTokenStoreProtocol, logger: Logger) {
        self.deviceTokenStore = deviceTokenStore
        self.logger = logger
    }

    func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            if let error = error {
                self?.logger.error("PushNotificationService: auth failed \(error)")
                return
            }
            self?.logger.info("PushNotificationService: auth granted \(granted)")
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func didRegister(deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        do {
            try deviceTokenStore.save(token)
            logger.info("PushNotificationService: device token saved")
        } catch {
            logger.error("PushNotificationService: save token failed \(error)")
        }
    }

    func didFailToRegister(error: Error) {
        logger.error("PushNotificationService: failed to register \(error)")
    }
}
