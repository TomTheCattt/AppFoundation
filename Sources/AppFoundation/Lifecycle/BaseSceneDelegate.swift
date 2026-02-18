//
//  BaseSceneDelegate.swift
//  AppFoundation
//
//  Created by AppFoundation Package.
//

import UIKit

open class BaseSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    open var window: UIWindow?
    
    open func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        // Setup Window
    }
    
    open func sceneDidEnterBackground(_ scene: UIScene) {
        LifecycleManager.shared.onBackground()
    }
    
    open func sceneWillEnterForeground(_ scene: UIScene) {
        LifecycleManager.shared.onForeground()
    }
}
