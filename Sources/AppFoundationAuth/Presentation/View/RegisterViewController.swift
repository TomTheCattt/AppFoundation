//
//  RegisterViewController.swift
//  AppFoundation
//

import UIKit
import AppFoundation
import AppFoundationUI
import Combine

final class RegisterViewController: BaseViewController<RegisterViewModel> {
    private let coordinator: AuthCoordinatorProtocol

    private let emailField: StandardTextField = {
        let f = StandardTextField()
        f.placeholder = "Email"
        f.keyboardType = .emailAddress
        f.autocapitalizationType = .none
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()

    private let passwordField: SecureTextField = {
        let f = SecureTextField()
        f.placeholder = "Password"
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()

    private let registerButton = PrimaryButton()

    private lazy var loadingOverlay: ActivityIndicator = {
        let v = ActivityIndicator(frame: view.bounds)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()

    init(viewModel: RegisterViewModel, coordinator: AuthCoordinatorProtocol) {
        self.coordinator = coordinator
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func setupUI() {
        super.setupUI()
        title = "Register"
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        view.addSubview(loadingOverlay)
        registerButton.setTitle("Register", for: .normal)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)

        emailField.accessibilityIdentifier = AccessibilityIdentifier.TextField.email
        passwordField.accessibilityIdentifier = AccessibilityIdentifier.TextField.password
        registerButton.accessibilityIdentifier = AccessibilityIdentifier.Button.submit
    }

    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            emailField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            registerButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24),
            registerButton.heightAnchor.constraint(equalToConstant: 48),
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func setupBindings() {
        super.setupBindings()
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in self?.render(state: state) }
            .store(in: &cancellables)
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                if loading { self?.loadingOverlay.startAnimating() }
                else { self?.loadingOverlay.stopAnimating() }
            }
            .store(in: &cancellables)
    }

    private func render(state: AuthViewState) {
        switch state {
        case .idle, .loading: break
        case .success: break
        case .error(let error):
            loadingOverlay.stopAnimating()
            handleError(error)
        }
    }

    @objc private func didTapRegister() {
        viewModel.register(email: emailField.text ?? "", password: passwordField.text ?? "")
    }
}
