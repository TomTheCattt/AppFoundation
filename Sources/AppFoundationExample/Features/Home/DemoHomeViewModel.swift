//
//  DemoHomeViewModel.swift
//  AppFoundationExample
//
//  Created by AppFoundation Package.
//

import Foundation
import AppFoundationUI

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
