//
//  ProfileViewController.swift
//  BaseIOSApp
//

import UIKit
import Combine

final class ProfileViewController: BaseViewController {
    private let viewModel: ProfileViewModel

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = DesignSystemTypography.title2.font
        l.textColor = DesignSystemColors.textPrimary.uiColor
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let emailLabel: UILabel = {
        let l = UILabel()
        l.font = DesignSystemTypography.body.font
        l.textColor = DesignSystemColors.textSecondary.uiColor
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let logoutButton = SecondaryButton()

    private lazy var loadingOverlay: ActivityIndicator = {
        let v = ActivityIndicator(frame: view.bounds)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func setupUI() {
        super.setupUI()
        title = "Profile"
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(logoutButton)
        view.addSubview(loadingOverlay)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
    }

    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            logoutButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 32),
            logoutButton.heightAnchor.constraint(equalToConstant: 48),
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadProfile()
    }

    private func render(state: ProfileViewState) {
        switch state {
        case .idle, .loading: break
        case .loaded(let user):
            nameLabel.text = user.displayName
            emailLabel.text = user.email
        case .error(let error):
            loadingOverlay.stopAnimating()
            showError(error)
        }
    }

    @objc private func didTapLogout() {
        viewModel.logout()
    }
}
