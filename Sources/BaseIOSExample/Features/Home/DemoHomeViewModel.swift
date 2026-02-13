//
//  DemoHomeViewModel.swift
//  BaseIOSExample
//
//  Created by BaseIOSApp Package.
//

import Foundation
import BaseIOSUI

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
