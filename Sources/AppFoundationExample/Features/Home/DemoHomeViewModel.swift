//
//  DemoHomeViewModel.swift
//  AppFoundationExample
//
//  Created by AppFoundation Package.
//

import AppFoundationUI
import Foundation

class DemoHomeViewModel: BaseViewModel {
    private let coordinator: DemoAppCoordinator
    
    init(coordinator: DemoAppCoordinator) {
        self.coordinator = coordinator
    }
    
    func logout() {
        // Clear TokenStore...
        coordinator.showLogin()
    }
}
