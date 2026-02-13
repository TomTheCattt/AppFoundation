//
//  DemoAppCoordinator.swift
//  AppFoundationExample
//
//  Created by AppFoundation Package.
//

import AppFoundation
import AppFoundationAuth
import AppFoundationUI
import UIKit

class DemoAppCoordinator {
    let window: UIWindow
    let navigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        checkAutoLogin()
    }
    
    private func checkAutoLogin() {
        // Simulate check
        let hasToken = true // Skip login for faster feature testing
        
        if hasToken {
            showFeatureList()
        } else {
            showLogin()
        }
    }
    
    func showLogin() {
        let viewModel = DemoLoginViewModel(coordinator: self)
        let vc = DemoLoginViewController(viewModel: viewModel)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showFeatureList() {
        let viewModel = FeatureListViewModel(coordinator: self)
        let vc = FeatureListViewController(viewModel: viewModel)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showNetworkDemo() {
        let vc = NetworkDemoViewController(viewModel: NetworkDemoViewModel())
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showStorageDemo() {
        let vc = StorageDemoViewController(viewModel: StorageDemoViewModel())
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSettingsDemo() {
       // Theme switching etc.
       let vc = SettingsDemoViewController(viewModel: SettingsDemoViewModel(coordinator: self))
       navigationController.pushViewController(vc, animated: true)
    }
    
    func logout() {
        showLogin()
    }
}
