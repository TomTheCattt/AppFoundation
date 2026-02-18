//
//  DIContainer.swift
//  AppFoundation
//
//  Created by AppFoundation Package.
//

import Foundation
import Swinject

/// A simple wrapper around Swinject Container to provide dependency injection.
public final class DIContainer {
    public static let shared = DIContainer()
    public let container: Container
    
    // Allow custom container for testing
    public init(container: Container = Container()) {
        self.container = container
    }
    
    public func register<Service>(_ serviceType: Service.Type, factory: @escaping (Resolver) -> Service) {
        container.register(serviceType, factory: factory)
    }
    
    public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        container.resolve(serviceType)
    }
    
    // Helper to resolve safe or fatal error
    public func resolveSafe<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = resolve(serviceType) else {
            fatalError("Dependency \(serviceType) not registered in DIContainer")
        }
        return service
    }
}
