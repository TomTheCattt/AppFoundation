//
//  Coordinator.swift
//  BaseIOSApp
//
//  Coordinator protocol and base implementation for navigation flows.
//

import UIKit

public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }

    func start()
    func finish()

    func addChild(_ coordinator: Coordinator)
    func removeChild(_ coordinator: Coordinator)
}

extension Coordinator {
    public func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }

    public func removeChild(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }

    func finish() {
        parentCoordinator?.removeChild(self)
    }
}

// MARK: - Base Coordinator
open class BaseCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public weak var parentCoordinator: Coordinator?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    open func start() {
        fatalError("Start method must be implemented by child coordinators")
    }

    public func finish() {
        parentCoordinator?.removeChild(self)
    }

    public func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }

    public func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
