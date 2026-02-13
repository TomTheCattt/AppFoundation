import UIKit
import BaseIOSUI
import BaseIOSAuth
import BaseIOSCore

final class ProfileViewModel: BaseViewModel {
    let logoutUseCase: LogoutUseCaseProtocol
    let logger: Logger
    let onLogout: () -> Void

    // Loading state publishers etc are inherited from BaseViewModel

    init(getCurrentUserUseCase: GetCurrentUserUseCaseProtocol,
         logoutUseCase: LogoutUseCaseProtocol,
         logger: Logger,
         onLogout: @escaping () -> Void) {
        self.logoutUseCase = logoutUseCase
        self.logger = logger
        self.onLogout = onLogout
        super.init()
    }
}

final class ProfileViewController: BaseViewController<ProfileViewModel> {
    override func setupUI() {
        super.setupUI()
        title = "Profile"
        view.backgroundColor = .systemBackground
        
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func logoutTapped() {
        viewModel.onLogout()
    }
}
