import UIKit
import BaseIOSUI
import BaseIOSCore

final class FeatureCoordinator: BaseCoordinator {
    private let diContainer: DIContainer
    private let logger: Logger

    // Match signature expected by TabBarCoordinator
    init(navigationController: UINavigationController, diContainer: DIContainer, logger: Logger) {
        self.diContainer = diContainer
        self.logger = logger
        super.init(navigationController: navigationController)
    }

    override func start() {
        let vc = PlaceholderViewController(title: "Home Feature")
        navigationController.setViewControllers([vc], animated: false)
    }
}
