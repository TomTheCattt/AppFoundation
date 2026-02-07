//
//  BaseViewController.swift
//  BaseIOSApp
//
//  Base class for all ViewControllers. Override setupUI, setupConstraints,
//  setupBindings, configureNavigationBar, applyTheme to assign behaviour.
//

import UIKit
import Combine

class BaseViewController: UIViewController {

    // MARK: - Properties

    /// Activity indicator for loading states. Add to view in showLoading().
    private(set) lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    /// Cancellables for Combine subscriptions.
    var cancellables = Set<AnyCancellable>()

    /// DI Container access.
    var container: DIContainer {
        DIContainer.shared
    }

    /// Logger. Override if you need a different logger.
    var logger: Logger {
        container.resolve(Logger.self)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupBindings()
        configureNavigationBar()
        observeThemeChanges()
        onViewDidLoad()
        logger.debug("[\(type(of: self))] viewDidLoad")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewWillAppear(animated)
        logger.debug("[\(type(of: self))] viewWillAppear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onViewDidAppear(animated)
        logger.debug("[\(type(of: self))] viewDidAppear")
    }

    deinit {
        logger.debug("[\(type(of: self))] deinit")
    }

    // MARK: - Override points (subclass only override these to assign actions)

    /// Setup UI elements. Override to add subviews, colors, etc.
    func setupUI() {
        view.backgroundColor = DesignSystemColors.background.uiColor
    }

    /// Setup Auto Layout constraints. Override to layout subviews.
    func setupConstraints() {}

    /// Setup data bindings and button actions. Override to add targets, Combine, etc.
    func setupBindings() {}

    /// Configure navigation bar (title, left/right items). Override to customize.
    func configureNavigationBar() {}

    /// Called after viewDidLoad setup. Override for extra setup or side effects.
    func onViewDidLoad() {}

    /// Called from viewWillAppear. Override to refresh data or update UI.
    func onViewWillAppear(_ animated: Bool) {}

    /// Called from viewDidAppear. Override for analytics or focus.
    func onViewDidAppear(_ animated: Bool) {}

    /// View that will contain the loading indicator. Override to use a different container.
    func loadingContainerView() -> UIView {
        view
    }

    /// Called when pull-to-refresh is triggered. Override and add UIRefreshControl in setupUI.
    func handleRefresh() {}

    // MARK: - Loading State

    func showLoading() {
        let containerView = loadingContainerView()
        if activityIndicator.superview == nil {
            containerView.addSubview(activityIndicator)
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
        }
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }

    // MARK: - Error Handling

    func showError(_ error: Error) {
        let errorPresenter: ErrorPresenter = container.resolve(ErrorPresenter.self)
        errorPresenter.present(error, in: self)
    }

    func showError(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Theme Support

    private func observeThemeChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChange),
            name: .themeDidChange,
            object: nil
        )
    }

    @objc private func themeDidChange() {
        applyTheme()
    }

    /// Apply current theme. Override in subclasses for custom theming.
    func applyTheme() {
        view.backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        ThemeManager.shared.currentTheme.statusBarStyle
    }

    // MARK: - Keyboard

    /// Call from setupBindings if this screen needs keyboard observation.
    func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        // Override in subclasses
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        // Override in subclasses
    }

    // MARK: - Helpers

    func dismissKeyboard() {
        view.endEditing(true)
    }
}
