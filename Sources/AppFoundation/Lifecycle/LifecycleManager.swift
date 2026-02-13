//
//  LifecycleManager.swift
//  AppFoundation
//
//  Created by AppFoundation Package.
//

import UIKit
import Combine

public final class LifecycleManager {
    public static let shared = LifecycleManager()
    
    private var isBootstrapped = false
    
    private init() {}
    
    public func bootstrap(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard !isBootstrapped else { return }
        
        // 1. Setup Logger (First!)
        setupLogger()
        
        // 2. Setup DI (Dependencies)
        setupDependencies()
        
        // 3. Setup Network
        setupNetwork()
        
        // 4. Setup Auth (User Session)
        checkUserSession()
        
        isBootstrapped = true
        Logger.shared.info("LifecycleManager: App boostrapped successfully")
    }
    
    public func onBackground() {
        Logger.shared.debug("LifecycleManager: App entering background")
        // Pause API Queue
        // Clear Kingfisher Cache
        // Save State
    }
    
    public func onForeground() {
        Logger.shared.debug("LifecycleManager: App entering foreground")
        // Resume API Queue
        // Refresh Session
        // Check Remote Config
    }
    
    // MARK: - Private Setup Methods
    
    private func setupLogger() {
        // Implementation dependent on internal Logger class
        // Logger.shared.addDestination(...)
    }
    
    private func setupDependencies() {
        // Load DI Container
    }
    
    private func setupNetwork() {
        // Init APIClient, NetworkMonitor
    }
    
    private func checkUserSession() {
        // Check TokenStore
    }
}
