//
//  SecondaryButton.swift
//  AppFoundation
//
//  Secondary (outline) button. Override or use target/action for behaviour.
//

import UIKit

public final class SecondaryButton: UIButton {

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public convenience init(title: String) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
    }

    // MARK: - Setup

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        setupConfiguration()
        setupLayout()
        setupInteractions()
        setupAccessibility()
    }

    // MARK: - Configuration (iOS 15+)

    private func setupConfiguration() {
        var config = UIButton.Configuration.plain()

        config.baseBackgroundColor = .clear
        config.baseForegroundColor = DesignSystemColors.primary.uiColor

        config.contentInsets = NSDirectionalEdgeInsets(
            top: DesignSystemSpacing.xs,
            leading: DesignSystemSpacing.md,
            bottom: DesignSystemSpacing.xs,
            trailing: DesignSystemSpacing.md
        )

        configuration = config

        // Border + font + state update
        configurationUpdateHandler = { button in

            // Font
            button.configuration?.attributedTitle =
                AttributedString(
                    button.currentTitle ?? "",
                    attributes: AttributeContainer([
                        .font: DesignSystemTypography.bodyBold.font
                    ])
                )

            // Alpha
            button.alpha = button.isEnabled ? 1.0 : 0.5

            // Border color fade when disabled
            let borderColor = DesignSystemColors.primary.uiColor
                .withAlphaComponent(button.isEnabled ? 1.0 : 0.5)

            button.layer.borderColor = borderColor.cgColor
        }

        // Border styling
        layer.cornerRadius = DesignSystemCornerRadius.sm
        layer.borderWidth = DesignSystemBorderWidth.medium
        layer.masksToBounds = true
    }

    // MARK: - Layout

    private func setupLayout() {
        heightAnchor
            .constraint(greaterThanOrEqualToConstant: 48)
            .isActive = true
    }

    // MARK: - Interactions

    private func setupInteractions() {
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(
            self,
            action: #selector(touchUp),
            for: [.touchUpInside, .touchUpOutside, .touchCancel]
        )
    }

    @objc private func touchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    @objc private func touchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }

    // MARK: - Accessibility

    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityIdentifier = AccessibilityIdentifier.Button.secondary
    }
}

