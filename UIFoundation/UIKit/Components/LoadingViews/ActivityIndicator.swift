//
//  ActivityIndicator.swift
//  BaseIOSApp
//
//  Full-screen or inline activity indicator view.
//

import UIKit

final class ActivityIndicator: UIView {

    private let indicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = DesignSystemColors.background.uiColor.withAlphaComponent(0.8)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func startAnimating() {
        indicator.startAnimating()
        isHidden = false
    }

    func stopAnimating() {
        indicator.stopAnimating()
        isHidden = true
    }
}
