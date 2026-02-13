//
//  BaseAppDelegate.swift
//  BaseIOSCore
//
//  Created by BaseIOSApp Package.
//

import UIKit

open class BaseAppDelegate: UIResponder, UIApplicationDelegate {
    
    open var window: UIWindow?
    
    open func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Auto-bootstrap core services
        LifecycleManager.shared.bootstrap(launchOptions: launchOptions)
        
        return true
    }
    
    open func applicationDidEnterBackground(_ application: UIApplication) {
        LifecycleManager.shared.onBackground()
    }
    
    open func applicationWillEnterForeground(_ application: UIApplication) {
        LifecycleManager.shared.onForeground()
    }
    
    // MARK: - Push Notifications
    
    open func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // Handle Push Token
        Logger.shared.info("Did register for remote notifications")
    }
    
    open func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        Logger.shared.error("Failed to register for notifications: \(error)")
    }
}
