//
//  SecureTextField.swift
//  BaseIOSApp
//
//  Secure (password) text field with optional show/hide toggle.
//

import UIKit
import Combine

final class SecureTextField: StandardTextField {

    private var cancellables = Set<AnyCancellable>()
    private var isSecure = true

    private lazy var toggleButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        btn.tintColor = DesignSystemColors.textSecondary.uiColor
        btn.addTarget(self, action: #selector(toggleSecure), for: .touchUpInside)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isSecureTextEntry = true
        setupToggle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isSecureTextEntry = true
        setupToggle()
    }

    private func setupToggle() {
        rightView = nil
        rightViewMode = .never
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        toggleButton.frame = container.bounds
        container.addSubview(toggleButton)
        rightView = container
        rightViewMode = .always
        accessibilityIdentifier = AccessibilityIdentifier.TextField.password
    }

    @objc private func toggleSecure() {
        isSecure.toggle()
        isSecureTextEntry = isSecure
        toggleButton.setImage(
            UIImage(systemName: isSecure ? "eye.slash" : "eye"),
            for: .normal
        )
    }
}
