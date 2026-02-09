//
//  RegisterViewModel.swift
//  BaseIOSApp
//

import Foundation
import Combine

protocol RegisterViewModelProtocol: AnyObject {
    var statePublisher: AnyPublisher<AuthViewState, Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    func register(email: String, password: String)
}

final class RegisterViewModel: RegisterViewModelProtocol {
    @Published private(set) var state: AuthViewState = .idle
    @Published private(set) var isLoading: Bool = false

    var statePublisher: AnyPublisher<AuthViewState, Never> { $state.eraseToAnyPublisher() }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { $isLoading.eraseToAnyPublisher() }

    private let registerUseCase: RegisterUseCaseProtocol
    private let logger: Logger
    private var onRegisterSuccess: () -> Void

    init(registerUseCase: RegisterUseCaseProtocol, logger: Logger, onRegisterSuccess: @escaping () -> Void) {
        self.registerUseCase = registerUseCase
        self.logger = logger
        self.onRegisterSuccess = onRegisterSuccess
    }

    func register(email: String, password: String) {
        guard !isLoading else { return }
        state = .loading
        isLoading = true

        Task { @MainActor in
            do {
                try await registerUseCase.execute(email: email, password: password)
                isLoading = false
                state = .success
                logger.info("RegisterViewModel: register success")
                onRegisterSuccess()
            } catch {
                isLoading = false
                state = .error(error)
                logger.error("RegisterViewModel: register failed \(error)")
            }
        }
    }
}
