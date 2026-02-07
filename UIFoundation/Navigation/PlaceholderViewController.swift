//
//  PlaceholderViewController.swift
//  BaseIOSApp
//
//  Simple placeholder screen used by coordinators until real screens exist.
//

import UIKit

final class PlaceholderViewController: BaseViewController {

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

    override func setupUI() {
        super.setupUI()
        view.addSubview(titleLabel)
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
