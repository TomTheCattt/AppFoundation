//
//  AppDelegate.swift
//  BaseIOSApp
//
//  Application lifecycle, push notifications, background tasks.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        AppBootstrapper.bootstrap()
        
        // Fallback if SceneDelegate is not used (e.g. testing)
        if #available(iOS 13, *), Bundle.main.infoDictionary?["UIApplicationSceneManifest"] != nil {
             // SceneDelegate handles it
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            self.window = window
            appCoordinator = AppCoordinator(window: window)
            appCoordinator?.start()
        }
        
        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let pushService: PushNotificationServiceProtocol = DIContainer.shared.resolve(PushNotificationServiceProtocol.self)
        pushService.didRegister(deviceToken: deviceToken)
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        let pushService: PushNotificationServiceProtocol = DIContainer.shared.resolve(PushNotificationServiceProtocol.self)
        pushService.didFailToRegister(error: error)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Logger.shared.info("Application will terminate")
    }
}
