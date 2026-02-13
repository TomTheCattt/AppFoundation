//
//  DemoHomeViewController.swift
//  BaseIOSExample
//
//  Created by BaseIOSApp Package.
//

import UIKit
import BaseIOSUI

class DemoHomeViewController: BaseViewController<DemoHomeViewModel> {
    
    private let label = UILabel()
    private let logoutBtn = UIButton(type: .system)
    
    override func setupUI() {
        title = "Home"
        
        label.text = "Welcome Home!"
        label.font = ThemeManager.shared.fonts.heading1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        logoutBtn.setTitle("Logout", for: .normal)
        logoutBtn.addTarget(self, action: #selector(onLogoutTap), for: .touchUpInside)
        logoutBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(logoutBtn)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            logoutBtn.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            logoutBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func onLogoutTap() {
        viewModel.logout()
    }
}
