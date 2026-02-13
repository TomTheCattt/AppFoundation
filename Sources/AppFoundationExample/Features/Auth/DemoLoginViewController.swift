//
//  DemoLoginViewController.swift
//  AppFoundationExample
//
//  Created by AppFoundation Package.
//

import UIKit
import AppFoundationUI
import AppFoundationResources

class DemoLoginViewController: BaseViewController<DemoLoginViewModel> {
    
    private let stackView = UIStackView()
    private let emailField = UITextField()
    private let passField = UITextField()
    private let loginBtn = UIButton(type: .system)
    
    override func setupUI() {
        title = "Demo Login"
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        emailField.placeholder = "Email (type 'success')"
        emailField.borderStyle = .roundedRect
        emailField.autocapitalizationType = .none
        
        passField.placeholder = "Password"
        passField.borderStyle = .roundedRect
        passField.isSecureTextEntry = true
        
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.addTarget(self, action: #selector(onLoginTap), for: .touchUpInside)
        
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passField)
        stackView.addArrangedSubview(loginBtn)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    @objc private func onLoginTap() {
        guard let email = emailField.text, let pass = passField.text else { return }
        viewModel.login(email: email, pass: pass)
    }
}
