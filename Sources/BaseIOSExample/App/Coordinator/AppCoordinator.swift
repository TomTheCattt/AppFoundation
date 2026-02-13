//
//  AppCoordinator.swift
//  BaseIOSApp
//
//  Root coordinator: auth/main flow, deep link routing.
//

import UIKit
import BaseIOSCore

final class AppCoordinator: BaseCoordinator {

    private let window: UIWindow
    private let container: DIContainer
    private let logger: Logger

    init(window: UIWindow, container: DIContainer = .shared) {
        self.window = window
        self.container = container
        self.logger = container.resolve(Logger.self)
        super.init(navigationController: BaseNavigationController())
    }

    override func start() {
        logger.info("AppCoordinator started")

        if isUserAuthenticated() {
            showMainFlow()
        } else {
            showAuthFlow()
        }

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func showAuthFlow() {
        logger.info("Showing Auth Flow")
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            container: container,
            logger: logger
        )
        addChild(authCoordinator)
        authCoordinator.start(onAuthSuccess: { [weak self] in
            self?.userDidLogin()
        })
    }

    private func showMainFlow() {
        logger.info("Showing Main Flow")
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            container: container,
            onLogout: { [weak self] in
                self?.userDidLogout()
            }
        )
        addChild(tabBarCoordinator)
        tabBarCoordinator.start()
    }

    private func isUserAuthenticated() -> Bool {
        let tokenStore: TokenStoreProtocol = container.resolve(TokenStoreProtocol.self)
        return tokenStore.isAuthenticated
    }

    func userDidLogin() {
        logger.info("User logged in")
        showMainFlow()
    }

    func userDidLogout() {
        logger.info("User logged out")
        childCoordinators.removeAll()
        showAuthFlow()
    }

    func handleDeepLink(_ url: URL) {
        logger.info("Handling deep link: \(url)")

        let deepLinkHandler: DeepLinkHandler = container.resolve(DeepLinkHandler.self)

        guard let route = deepLinkHandler.parse(url) else {
            logger.info("Failed to parse deep link: \(url)")
            return
        }

        navigate(to: route)
    }

    private func navigate(to route: DeepLinkRoute) {
        switch route {
        case .home:
            showMainFlow()
        case .profile:
            break
        case .article(let id):
            logger.info("Navigate to article: \(id)")
        case .settings, .notification:
            break
        }
    }
}
