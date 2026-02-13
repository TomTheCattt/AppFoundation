//
//  SettingsDemoViewController.swift
//  AppFoundationExample
//
//  Created by AppFoundation Package.
//

import AppFoundationUI
import UIKit

class SettingsDemoViewController: BaseViewController<SettingsDemoViewModel> {
    
    let btnTheme = UIButton(type: .system)
    let btnLogout = UIButton(type: .system)
    
    override func setupUI() {
        title = "Settings"
        
        btnTheme.setTitle("Switch to Dark Theme (Orange)", for: .normal)
        btnTheme.addTarget(self, action: #selector(tapTheme), for: .touchUpInside)
        
        btnLogout.setTitle("Logout", for: .normal)
        btnLogout.addTarget(self, action: #selector(tapLogout), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [btnTheme, btnLogout])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func tapTheme() {
        viewModel.switchToDarkTheme()
        // Hack to refresh generic UI for demo without reloading everything
        view.backgroundColor = .black
    }
    
    @objc func tapLogout() {
        viewModel.logout()
    }
}
