//
//  LoginViewModel.swift
//  AppFoundation
//

import AppFoundation
import Combine
import Foundation

import AppFoundationUI

final class LoginViewModel: BaseViewModel, LoginViewModelProtocol {
    @Published private(set) var state: AuthViewState = .idle

    var statePublisher: AnyPublisher<AuthViewState, Never> { $state.eraseToAnyPublisher() }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { $isLoading.eraseToAnyPublisher() }

    private let loginUseCase: LoginUseCaseProtocol
    private let logger: Logger
    private var onLoginSuccess: () -> Void

    init(loginUseCase: LoginUseCaseProtocol, logger: Logger, onLoginSuccess: @escaping () -> Void) {
        self.loginUseCase = loginUseCase
        self.logger = logger
        self.onLoginSuccess = onLoginSuccess
        super.init()
    }

    func login(email: String, password: String) {
        guard !isLoading else { return }
        state = .loading
        isLoading = true

        Task { @MainActor in
            do {
                try await loginUseCase.execute(email: email, password: password)
                isLoading = false
                state = .success
                logger.info("LoginViewModel: login success")
                onLoginSuccess()
            } catch {
                isLoading = false
                state = .error(error)
                logger.error("LoginViewModel: login failed \(error)")
            }
        }
    }
}
