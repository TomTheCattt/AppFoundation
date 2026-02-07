//
//  TextButton.swift
//  BaseIOSApp
//
//  Text-only (flat) button, no background. For secondary actions.
//

import UIKit

final class TextButton: UIButton {

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
        setTitleColor(DesignSystemColors.textSecondary.uiColor, for: .disabled)
        titleLabel?.font = DesignSystemTypography.bodyBold.font

        contentEdgeInsets = UIEdgeInsets(
            top: DesignSystemSpacing.xxs,
            left: DesignSystemSpacing.xs,
            bottom: DesignSystemSpacing.xxs,
            right: DesignSystemSpacing.xs
        )

        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }

    @objc private func touchDown() {
        alpha = 0.7
    }

    @objc private func touchUp() {
        alpha = isEnabled ? 1.0 : 0.5
    }
}
