//
//  NetworkDemoViewController.swift
//  BaseIOSExample
//
//  Created by BaseIOSApp Package.
//

import UIKit
import BaseIOSUI
import BaseIOSCore

class NetworkDemoViewController: BaseViewController<NetworkDemoViewModel> {
    
    let label = UILabel()
    let btnNetwork = UIButton(type: .system)
    let btnCache = UIButton(type: .system)
    let stack = UIStackView()
    
    override func setupUI() {
        title = "Network Demo"
        
        label.text = "Result will appear here"
        label.numberOfLines = 0
        label.textAlignment = .center
        
        btnNetwork.setTitle("Fetch (Network First)", for: .normal)
        btnNetwork.addTarget(self, action: #selector(tapNetwork), for: .touchUpInside)
        
        btnCache.setTitle("Fetch (Cache Only)", for: .normal)
        btnCache.addTarget(self, action: #selector(tapCache), for: .touchUpInside)
        
        stack.axis = .vertical
        stack.spacing = 20
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(btnNetwork)
        stack.addArrangedSubview(btnCache)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    override func setupBindings() {
        super.setupBindings()
        viewModel.$resultText
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: label)
            .store(in: &cancellables)
    }
    
    @objc func tapNetwork() {
        viewModel.fetchPosts(strategy: .networkFirst)
    }
    
    @objc func tapCache() {
        viewModel.fetchPosts(strategy: .cacheOnly)
    }
}
