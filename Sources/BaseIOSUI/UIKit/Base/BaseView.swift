//
//  BaseView.swift
//  BaseIOSApp
//
//  Base UIView for programmatic layout. Override setupView and setupConstraints.
//

import UIKit

class BaseView: UIView {

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }

    // MARK: - Override points

    /// Setup subviews and appearance. Override to add subviews and set colors.
    func setupView() {
        backgroundColor = DesignSystemColors.background.uiColor
    }

    /// Setup Auto Layout constraints. Override to layout subviews.
    func setupConstraints() {}
}
