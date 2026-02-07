//
//  AuthCoordinator.swift
//  BaseIOSApp
//

import UIKit

final class AuthCoordinator: BaseCoordinator, AuthCoordinatorProtocol {
    private let container: DIContainer
    private let logger: Logger
    private var onAuthSuccess: (() -> Void)?

    init(navigationController: UINavigationController, container: DIContainer, logger: Logger) {
        self.container = container
        self.logger = logger
        super.init(navigationController: navigationController)
    }

    func start(onAuthSuccess: @escaping () -> Void) {
        self.onAuthSuccess = onAuthSuccess
        logger.info("AuthCoordinator - Starting")
        showLogin()
    }

    func didFinishAuthSuccess() {
        onAuthSuccess?()
    }

    private func showLogin() {
        let viewModel = makeLoginViewModel()
        let vc = LoginViewController(viewModel: viewModel, coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }

    private func makeLoginViewModel() -> LoginViewModel {
        let loginUseCase: LoginUseCaseProtocol = container.resolve(LoginUseCaseProtocol.self)
        let logger: Logger = container.resolve(Logger.self)
        return LoginViewModel(loginUseCase: loginUseCase, logger: logger) { [weak self] in
            self?.didFinishAuthSuccess()
        }
    }
}
