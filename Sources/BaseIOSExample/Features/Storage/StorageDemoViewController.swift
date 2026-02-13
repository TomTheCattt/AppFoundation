//
//  StorageDemoViewController.swift
//  BaseIOSExample
//
//  Created by BaseIOSApp Package.
//

import UIKit
import BaseIOSUI

class StorageDemoViewController: BaseViewController<StorageDemoViewModel> {
    
    let label = UILabel()
    let btnCoreData = UIButton(type: .system)
    let btnBio = UIButton(type: .system)
    let stack = UIStackView()
    
    override func setupUI() {
        title = "Storage & Security"
        
        label.text = "Status: Idle"
        
        btnCoreData.setTitle("Test CoreData Save", for: .normal)
        btnCoreData.addTarget(self, action: #selector(tapCoreData), for: .touchUpInside)
        
        btnBio.setTitle("Test FaceID/TouchID", for: .normal)
        btnBio.addTarget(self, action: #selector(tapBio), for: .touchUpInside)
        
        stack.axis = .vertical
        stack.spacing = 20
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(btnCoreData)
        stack.addArrangedSubview(btnBio)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func setupBindings() {
        super.setupBindings()
        viewModel.$status
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: label)
            .store(in: &cancellables)
    }
    
    @objc func tapCoreData() {
        viewModel.saveToCoreData()
    }
    
    @objc func tapBio() {
        viewModel.testBiometrics()
    }
}
