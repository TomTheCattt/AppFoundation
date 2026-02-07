//
//  ProfileViewModel.swift
//  BaseIOSApp
//

import Foundation
import Combine

final class ProfileViewModel {
    @Published private(set) var state: ProfileViewState = .idle
    @Published private(set) var isLoading: Bool = false

    var statePublisher: AnyPublisher<ProfileViewState, Never> { $state.eraseToAnyPublisher() }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { $isLoading.eraseToAnyPublisher() }

    private let getCurrentUserUseCase: GetCurrentUserUseCaseProtocol
    private let logoutUseCase: LogoutUseCaseProtocol
    private let logger: Logger
    private var onLogout: () -> Void

    init(
        getCurrentUserUseCase: GetCurrentUserUseCaseProtocol,
        logoutUseCase: LogoutUseCaseProtocol,
        logger: Logger,
        onLogout: @escaping () -> Void
    ) {
        self.getCurrentUserUseCase = getCurrentUserUseCase
        self.logoutUseCase = logoutUseCase
        self.logger = logger
        self.onLogout = onLogout
    }

    func loadProfile() {
        guard !isLoading else { return }
        state = .loading
        isLoading = true

        Task { @MainActor in
            do {
                let user = try await getCurrentUserUseCase.execute()
                isLoading = false
                state = .loaded(user)
            } catch {
                isLoading = false
                state = .error(error)
                logger.error("ProfileViewModel load failed: \(error)")
            }
        }
    }

    func logout() {
        Task { @MainActor in
            do {
                try await logoutUseCase.execute()
                onLogout()
            } catch {
                logger.error("ProfileViewModel logout failed: \(error)")
                onLogout()
            }
        }
    }
}
