//
//  CoreAssembly.swift
//  BaseIOSApp
//
//  Register core utilities: Logger, PerformanceMonitor, ErrorMapper.
//

import Foundation
import Swinject

final class CoreAssembly: Assembly {
    func assemble(container: Container) {
        container.register(Logger.self) { _ in
            Logger.shared
        }.inObjectScope(.container)

        container.register(PerformanceMonitor.self) { _ in
            PerformanceMonitor.shared
        }.inObjectScope(.container)

        container.register(ErrorMapper.self) { _ in
            ErrorMapper()
        }

        container.register(ErrorPresenter.self) { _ in
            ErrorPresenter()
        }

        container.register(TokenStoreProtocol.self) { _ in
            TokenStore()
        }.inObjectScope(.container)
    }
}
