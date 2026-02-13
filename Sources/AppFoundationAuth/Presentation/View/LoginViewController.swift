//
//  LoginViewController.swift
//  AppFoundation
//

import UIKit
import AppFoundation
import AppFoundationUI
import Combine

final class LoginViewController: BaseViewController<LoginViewModel> {
    
    // MARK: - Views
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

    private let loginButton: PrimaryButton = {
        let btn = PrimaryButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let signUpButton: SecondaryButton = {
        let btn = SecondaryButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private lazy var loadingOverlay: ActivityIndicator = {
        let v = ActivityIndicator(frame: view.bounds)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()

    init(viewModel: LoginViewModel, coordinator: AuthCoordinatorProtocol) {
        self.coordinator = coordinator
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func setupUI() {
        super.setupUI()
        title = "Login"
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        view.addSubview(loadingOverlay)
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        signUpButton.setTitle("Sign up", for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)

        emailField.accessibilityIdentifier = AccessibilityIdentifier.TextField.email
        passwordField.accessibilityIdentifier = AccessibilityIdentifier.TextField.password
        loginButton.accessibilityIdentifier = AccessibilityIdentifier.Button.submit
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
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signUpButton.heightAnchor.constraint(equalToConstant: 48),
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

    @objc private func didTapLogin() {
        viewModel.login(email: emailField.text ?? "", password: passwordField.text ?? "")
    }

    @objc private func didTapSignUp() {
        coordinator.showRegister()
    }
}
