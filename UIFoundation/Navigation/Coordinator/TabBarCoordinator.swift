//
//  TabBarCoordinator.swift
//  BaseIOSApp
//
//  Tab bar coordinator with Home, Search, Profile placeholders.
//

import UIKit

final class TabBarCoordinator: BaseCoordinator {

    private let container: DIContainer
    private let onLogout: (() -> Void)?
    private var tabBarController: UITabBarController!

    init(navigationController: UINavigationController, container: DIContainer, onLogout: (() -> Void)? = nil) {
        self.container = container
        self.onLogout = onLogout
        super.init(navigationController: navigationController)
    }

    override func start() {
        let tabBarController = UITabBarController()

        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = DesignSystemColors.background.uiColor
            tabBarController.tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBarController.tabBar.scrollEdgeAppearance = appearance
            }
        }

        tabBarController.tabBar.tintColor = DesignSystemColors.primary.uiColor
        tabBarController.tabBar.unselectedItemTintColor = DesignSystemColors.textSecondary.uiColor

        let homeCoordinator = createHomeCoordinator()
        let searchCoordinator = createSearchCoordinator()
        let profileCoordinator = createProfileCoordinator()

        addChild(homeCoordinator)
        addChild(searchCoordinator)
        addChild(profileCoordinator)

        homeCoordinator.start()
        searchCoordinator.start()
        profileCoordinator.start()

        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            searchCoordinator.navigationController,
            profileCoordinator.navigationController
        ]

        self.tabBarController = tabBarController
        navigationController.setViewControllers([tabBarController], animated: false)
    }

    private func createHomeCoordinator() -> Coordinator {
        let nav = BaseNavigationController()
        nav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: IconSet.Tab.home),
            selectedImage: UIImage(systemName: IconSet.Tab.homeFilled)
        )
        nav.tabBarItem.accessibilityIdentifier = AccessibilityIdentifier.Navigation.Tab.home
        return HomeTabCoordinator(navigationController: nav, container: container)
    }

    private func createSearchCoordinator() -> Coordinator {
        let nav = BaseNavigationController()
        nav.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: IconSet.Tab.search),
            selectedImage: UIImage(systemName: IconSet.Tab.search)
        )
        return SearchTabCoordinator(navigationController: nav, container: container)
    }

    private func createProfileCoordinator() -> Coordinator {
        let nav = BaseNavigationController()
        nav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: IconSet.Tab.profile),
            selectedImage: UIImage(systemName: IconSet.Tab.profileFilled)
        )
        return ProfileTabCoordinator(navigationController: nav, container: container, onLogout: onLogout)
    }
}

// MARK: - Tab coordinators (Phase 3: Feature module template on Home)
private final class HomeTabCoordinator: BaseCoordinator {
    private let container: DIContainer
    private let logger: Logger

    init(navigationController: UINavigationController, container: DIContainer) {
        self.container = container
        self.logger = container.resolve(Logger.self)
        super.init(navigationController: navigationController)
    }

    override func start() {
        let featureCoordinator = FeatureCoordinator(
            navigationController: navigationController,
            diContainer: container,
            logger: logger
        )
        addChild(featureCoordinator)
        featureCoordinator.start()
    }
}

private final class SearchTabCoordinator: BaseCoordinator {
    private let container: DIContainer

    init(navigationController: UINavigationController, container: DIContainer) {
        self.container = container
        super.init(navigationController: navigationController)
    }

    override func start() {
        navigationController.setViewControllers([PlaceholderViewController(title: "Search")], animated: false)
    }
}

private final class ProfileTabCoordinator: BaseCoordinator {
    private let container: DIContainer
    private let onLogout: (() -> Void)?

    init(navigationController: UINavigationController, container: DIContainer, onLogout: (() -> Void)? = nil) {
        self.container = container
        self.onLogout = onLogout
        super.init(navigationController: navigationController)
    }

    override func start() {
        let getCurrentUser: GetCurrentUserUseCaseProtocol = container.resolve(GetCurrentUserUseCaseProtocol.self)
        let logoutUseCase: LogoutUseCaseProtocol = container.resolve(LogoutUseCaseProtocol.self)
        let logger: Logger = container.resolve(Logger.self)
        let viewModel = ProfileViewModel(
            getCurrentUserUseCase: getCurrentUser,
            logoutUseCase: logoutUseCase,
            logger: logger,
            onLogout: onLogout ?? {}
        )
        let vc = ProfileViewController(viewModel: viewModel)
        navigationController.setViewControllers([vc], animated: false)
    }
}
