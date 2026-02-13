//
//  StandardTextField.swift
//  AppFoundation
//
//  Standard text field with validation state and focus styling.
//

import UIKit
import Combine

public class StandardTextField: UITextField {

    // MARK: - Properties

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemTypography.caption1.font
        label.textColor = DesignSystemColors.error.uiColor
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private var cancellables = Set<AnyCancellable>()

    var validationError: String? {
        didSet {
            updateValidationState()
        }
    }

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }

    // MARK: - Setup

    private func setup() {
        font = DesignSystemTypography.body.font
        textColor = DesignSystemColors.textPrimary.uiColor
        borderStyle = .none

        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 44))
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 44))
        rightViewMode = .always

        layer.cornerRadius = DesignSystemCornerRadius.sm
        layer.borderWidth = DesignSystemBorderWidth.thin
        layer.borderColor = DesignSystemColors.border.uiColor.cgColor

        heightAnchor.constraint(equalToConstant: 48).isActive = true

        NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification, object: self)
            .sink { [weak self] _ in
                self?.layer.borderColor = DesignSystemColors.primary.uiColor.cgColor
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification, object: self)
            .sink { [weak self] _ in
                self?.layer.borderColor = DesignSystemColors.border.uiColor.cgColor
            }
            .store(in: &cancellables)
    }

    // MARK: - Validation

    private func updateValidationState() {
        if let error = validationError, !error.isEmpty {
            layer.borderColor = DesignSystemColors.error.uiColor.cgColor
            errorLabel.text = error
            errorLabel.isHidden = false
        } else {
            layer.borderColor = DesignSystemColors.border.uiColor.cgColor
            errorLabel.isHidden = true
        }
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
        if errorLabel.superview == nil, let superview = superview {
            superview.addSubview(errorLabel)
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                errorLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 4),
                errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }
}
