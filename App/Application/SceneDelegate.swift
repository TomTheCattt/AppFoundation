//
//  SceneDelegate.swift
//  BaseIOSApp
//
//  Scene lifecycle, window and root setup. AppCoordinator drives navigation.
//

import UIKit

@objc(SceneDelegate)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        print("SceneDelegate connected")
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()

        if let urlContext = connectionOptions.urlContexts.first {
            appCoordinator?.handleDeepLink(urlContext.url)
        }

        if let userActivity = connectionOptions.userActivities.first {
            handleUniversalLink(userActivity)
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        appCoordinator?.handleDeepLink(url)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        handleUniversalLink(userActivity)
    }

    private func handleUniversalLink(_ userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else {
            return
        }
        appCoordinator?.handleDeepLink(url)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        Logger.shared.debug("Scene did enter background")
        let manager: BackgroundTaskManaging = DIContainer.shared.resolve(BackgroundTaskManaging.self)
        manager.scheduleAppRefresh(earliestBeginDate: Date(timeIntervalSinceNow: 15 * 60))
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        Logger.shared.debug("Scene will enter foreground")
        let syncManager: SyncManagerProtocol = DIContainer.shared.resolve(SyncManagerProtocol.self)
        syncManager.triggerSync()
    }
}
