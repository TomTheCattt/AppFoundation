//
//  NavigationCoordinator.swift
//  BaseIOSApp
//
//  Coordinator that uses a Router for push/present. Override start() and use router to navigate.
//

import UIKit

class NavigationCoordinator: BaseCoordinator {

    let router: Router

    override init(navigationController: UINavigationController) {
        self.router = NavigationRouter(navigationController: navigationController)
        super.init(navigationController: navigationController)
    }

    override func start() {
        fatalError("Subclasses must override start()")
    }
}
