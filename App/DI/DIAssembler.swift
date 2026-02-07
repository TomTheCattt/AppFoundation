//
//  DIAssembler.swift
//  BaseIOSApp
//
//  Orchestrate registration of all assemblies.
//

import Foundation
import Swinject

final class DIAssembler {
    static func assemble(container: Container) {
        let assemblies: [Assembly] = [
            CoreAssembly(),
            NetworkAssembly(),
            StorageAssembly(),
            UIFoundationAssembly(),
            FeatureAssembly(),
            AuthAssembly(),
            UserAssembly(),
            InfrastructureAssembly()
        ]
        assemblies.forEach { $0.assemble(container: container) }
    }
}
