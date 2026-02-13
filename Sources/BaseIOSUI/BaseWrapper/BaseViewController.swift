//
//  BaseViewController.swift
//  BaseIOSUI
//
//  Created by BaseIOSApp Package.
//

import UIKit
import Combine
import BaseIOSResources

open class BaseViewController<VM: BaseViewModel>: UIViewController {
    public let viewModel: VM
    public var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    public init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme()
        setupUI()
        setupBindings()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Setup
    open func setupTheme() {
        view.backgroundColor = ThemeManager.shared.colors.background
    }
    
    /// Override this method to setup static UI elements (views, constraints)
    open func setupUI() {
        // Default implementation does nothing
    }
    
    open func setupConstraints() {
        // Default implementation does nothing
    }
    
    open func setupBindings() {
        // Bind Loading
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.handleLoading(isLoading)
            }
            .store(in: &cancellables)
        
        // Bind Error
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Handlers (Overridable)
    open func handleLoading(_ isLoading: Bool) {
        if isLoading {
            DefaultLoadingView.shared.show(in: view)
        } else {
            DefaultLoadingView.shared.hide()
        }
    }
    
    open func handleError(_ error: Error) {
        let errorDisplay = AlertErrorDisplay() // Could be injected via DI
        errorDisplay.showError(error, in: self, retryAction: nil)
    }
}
