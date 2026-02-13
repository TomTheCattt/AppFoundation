//
//  TextButton.swift
//  BaseIOSApp
//
//  Text-only (flat) button, no background. For secondary actions.
//

import UIKit

final class TextButton: UIButton {

    // MARK: - Init

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

    // MARK: - Setup

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        setupConfiguration()
        setupInteractions()
    }

    // MARK: - Configuration (iOS 15+)

    private func setupConfiguration() {
        var config = UIButton.Configuration.plain()

        config.baseBackgroundColor = .clear
        config.baseForegroundColor = DesignSystemColors.primary.uiColor

        config.contentInsets = NSDirectionalEdgeInsets(
            top: DesignSystemSpacing.xxs,
            leading: DesignSystemSpacing.xs,
            bottom: DesignSystemSpacing.xxs,
            trailing: DesignSystemSpacing.xs
        )

        configuration = config

        configurationUpdateHandler = { button in

            // Font
            button.configuration?.attributedTitle =
                AttributedString(
                    button.currentTitle ?? "",
                    attributes: AttributeContainer([
                        .font: DesignSystemTypography.bodyBold.font
                    ])
                )

            // Text color state
            let textColor = button.isEnabled
                ? DesignSystemColors.primary.uiColor
                : DesignSystemColors.textSecondary.uiColor

            button.configuration?.baseForegroundColor = textColor

            // Alpha state
            button.alpha = button.isEnabled ? 1.0 : 0.5
        }
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
        alpha = 0.7
    }

    @objc private func touchUp() {
        alpha = isEnabled ? 1.0 : 0.5
    }
}

