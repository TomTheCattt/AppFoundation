//
//  PrimaryButton.swift
//  BaseIOSApp
//
//  Primary CTA button with loading state, disabled state, haptic feedback.
//

import UIKit

final class PrimaryButton: UIButton {

    // MARK: - Properties

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        return indicator
    }()

    private var originalTitle: String?

    var isLoading: Bool = false {
        didSet {
            updateLoadingState()
        }
    }

    // MARK: - Initialization

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
        backgroundColor = DesignSystemColors.primary.uiColor
        setTitleColor(.white, for: .normal)
        setTitleColor(.white.withAlphaComponent(0.5), for: .disabled)
        titleLabel?.font = DesignSystemTypography.bodyBold.font

        layer.cornerRadius = DesignSystemCornerRadius.sm
        layer.masksToBounds = true

        contentEdgeInsets = UIEdgeInsets(
            top: DesignSystemSpacing.xs,
            left: DesignSystemSpacing.md,
            bottom: DesignSystemSpacing.xs,
            right: DesignSystemSpacing.md
        )

        heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true

        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        isAccessibilityElement = true
        accessibilityIdentifier = AccessibilityIdentifier.Button.primary
    }

    // MARK: - State

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }

    private func updateLoadingState() {
        if isLoading {
            originalTitle = title(for: .normal)
            setTitle("", for: .normal)
            activityIndicator.startAnimating()
            isUserInteractionEnabled = false
        } else {
            setTitle(originalTitle, for: .normal)
            activityIndicator.stopAnimating()
            isUserInteractionEnabled = true
        }
    }

    // MARK: - Interactions

    @objc private func touchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            self.alpha = 0.8
        }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    @objc private func touchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.alpha = self.isEnabled ? 1.0 : 0.5
        }
    }
}
