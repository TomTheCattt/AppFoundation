//
//  PrimaryButton.swift
//  AppFoundation
//
//  Primary CTA button with loading state, disabled state, haptic feedback.
//

import UIKit

public final class PrimaryButton: UIButton {

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
        originalTitle = title
    }

    // MARK: - Setup

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        setupConfiguration()
        setupLayout()
        setupInteractions()
        setupAccessibility()
    }

    // MARK: - Configuration (iOS 15)

    private func setupConfiguration() {
        var config = UIButton.Configuration.filled()

        config.baseBackgroundColor = DesignSystemColors.primary.uiColor
        config.baseForegroundColor = .white

        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(
            top: DesignSystemSpacing.xs,
            leading: DesignSystemSpacing.md,
            bottom: DesignSystemSpacing.xs,
            trailing: DesignSystemSpacing.md
        )

        configuration = config

        configurationUpdateHandler = { button in

            button.alpha = button.isEnabled ? 1.0 : 0.5

            button.configuration?.attributedTitle =
                AttributedString(
                    button.currentTitle ?? "",
                    attributes: AttributeContainer([
                        .font: DesignSystemTypography.bodyBold.font
                    ])
                )
        }
    }

    // MARK: - Layout

    private func setupLayout() {
        heightAnchor
            .constraint(greaterThanOrEqualToConstant: 48)
            .isActive = true

        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
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
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            self.alpha = 0.8
        }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    @objc private func touchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.alpha = self.isEnabled ? 1.0 : 0.5
        }
    }

    // MARK: - Loading State

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

    // MARK: - Accessibility

    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityIdentifier = AccessibilityIdentifier.Button.primary
    }
}

