//
//  SecondaryButton.swift
//  BaseIOSApp
//
//  Secondary (outline) button. Override or use target/action for behaviour.
//

import UIKit

final class SecondaryButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    convenience init(title: String) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
    }

    private func setup() {
        backgroundColor = .clear
        setTitleColor(DesignSystemColors.primary.uiColor, for: .normal)
        setTitleColor(DesignSystemColors.primary.uiColor.withAlphaComponent(0.5), for: .disabled)
        titleLabel?.font = DesignSystemTypography.bodyBold.font

        layer.cornerRadius = DesignSystemCornerRadius.sm
        layer.borderWidth = DesignSystemBorderWidth.medium
        layer.borderColor = DesignSystemColors.primary.uiColor.cgColor
        layer.masksToBounds = true

        contentEdgeInsets = UIEdgeInsets(
            top: DesignSystemSpacing.xs,
            left: DesignSystemSpacing.md,
            bottom: DesignSystemSpacing.xs,
            right: DesignSystemSpacing.md
        )

        heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true

        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        accessibilityIdentifier = AccessibilityIdentifier.Button.secondary
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
            layer.borderColor = DesignSystemColors.primary.uiColor.withAlphaComponent(isEnabled ? 1 : 0.5).cgColor
        }
    }

    @objc private func touchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    @objc private func touchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
}
