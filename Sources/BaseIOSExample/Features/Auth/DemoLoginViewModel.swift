//
//  DemoLoginViewModel.swift
//  BaseIOSExample
//
//  Created by BaseIOSApp Package.
//

import Foundation
import BaseIOSUI
import BaseIOSCore

class DemoLoginViewModel: BaseViewModel {
    private let coordinator: DemoAppCoordinator
    // Pass in UseCases here via DI usually
    
    init(coordinator: DemoAppCoordinator) {
        self.coordinator = coordinator
    }
    
    func login(email: String, pass: String) {
        isLoading = true
        
        // Simulate API Call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            
            if email == "success" {
                // Success
                self?.coordinator.showHome()
            } else {
                // Fail
                self?.error = NetworkError.unauthorized(apiCode: "WRONG_PASS")
            }
        }
    }
}
