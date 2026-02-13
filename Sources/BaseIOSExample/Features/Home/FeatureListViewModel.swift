//
//  FeatureListViewModel.swift
//  BaseIOSExample
//
//  Created by BaseIOSApp Package.
//

import Foundation
import BaseIOSUI

enum DemoFeature: String, CaseIterable {
    case network = "Smart Network & Fallback"
    case storage = "Storage (CoreData/Disk/Keychain)"
    case settings = "Settings & Theme"
}

class FeatureListViewModel: BaseViewModel {
    private let coordinator: DemoAppCoordinator
    let features = DemoFeature.allCases
    
    init(coordinator: DemoAppCoordinator) {
        self.coordinator = coordinator
    }
    
    func didSelect(feature: DemoFeature) {
        switch feature {
        case .network:
            coordinator.showNetworkDemo()
        case .storage:
            coordinator.showStorageDemo()
        case .settings:
            coordinator.showSettingsDemo()
        }
    }
}
