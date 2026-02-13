//
//  PlaceholderViewController.swift
//  AppFoundation
//
//  Simple placeholder screen used by coordinators until real screens exist.
//

import UIKit
import AppFoundationResources

final class PlaceholderViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = DesignSystemTypography.title1.font
        label.textColor = DesignSystemColors.textPrimary.uiColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    func setupUI() {
        view.backgroundColor = .systemBackground // Manually set background
        view.addSubview(titleLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
