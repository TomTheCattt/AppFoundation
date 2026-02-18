//
//  AuthCoordinator.swift
//  AppFoundation
//

import AppFoundation
import AppFoundationUI
import UIKit

final public class AuthCoordinator: BaseCoordinator, AuthCoordinatorProtocol {
    private let container: DIContainer
    private let logger: Logger
    private var onAuthSuccess: (() -> Void)?

    public init(navigationController: UINavigationController, container: DIContainer, logger: Logger) {
        self.container = container
        self.logger = logger
        super.init(navigationController: navigationController)
    }

    public func start(onAuthSuccess: @escaping () -> Void) {
        self.onAuthSuccess = onAuthSuccess
        logger.info("AuthCoordinator - Starting")
        showLogin()
    }

    func didFinishAuthSuccess() {
        onAuthSuccess?()
    }

    @MainActor
    private func showLogin() {
        let viewModel = makeLoginViewModel()
        let vc = LoginViewController(viewModel: viewModel, coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }

    @MainActor
    func showRegister() {
        let viewModel = makeRegisterViewModel()
        let vc = RegisterViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }

    @MainActor
    private func makeRegisterViewModel() -> RegisterViewModel {
        let registerUseCase = container.resolveSafe(RegisterUseCaseProtocol.self)
        let logger = container.resolveSafe(Logger.self)
        return RegisterViewModel(registerUseCase: registerUseCase, logger: logger) { [weak self] in
            self?.didFinishAuthSuccess()
        }
    }

    @MainActor
    private func makeLoginViewModel() -> LoginViewModel {
        let loginUseCase = container.resolveSafe(LoginUseCaseProtocol.self)
        let logger = container.resolveSafe(Logger.self)
        return LoginViewModel(loginUseCase: loginUseCase, logger: logger) { [weak self] in
            self?.didFinishAuthSuccess()
        }
    }
}
