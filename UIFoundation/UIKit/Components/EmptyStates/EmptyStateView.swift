//
//  EmptyStateView.swift
//  BaseIOSApp
//
//  Empty state with optional image, title, message and action button.
//

import UIKit

class EmptyStateView: BaseView {

    var onAction: (() -> Void)?

    private let imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.tintColor = DesignSystemColors.textTertiary.uiColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = DesignSystemTypography.title3.font
        l.textColor = DesignSystemColors.textPrimary.uiColor
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.font = DesignSystemTypography.body.font
        l.textColor = DesignSystemColors.textSecondary.uiColor
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let actionButton = PrimaryButton()

    override func setupView() {
        super.setupView()
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        actionButton.isHidden = true
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: DesignSystemSpacing.md),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DesignSystemSpacing.md),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DesignSystemSpacing.md),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DesignSystemSpacing.xxs),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DesignSystemSpacing.md),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DesignSystemSpacing.md),

            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: DesignSystemSpacing.md),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(
        image: UIImage? = nil,
        title: String,
        message: String? = nil,
        actionTitle: String? = nil,
        onAction: (() -> Void)? = nil
    ) {
        imageView.image = image ?? UIImage(systemName: IconSet.Content.empty)
        imageView.isHidden = image == nil && imageView.image == nil
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.isHidden = (message ?? "").isEmpty
        self.onAction = onAction
        if let title = actionTitle {
            actionButton.setTitle(title, for: .normal)
            actionButton.isHidden = false
        } else {
            actionButton.isHidden = true
        }
    }

    @objc private func didTapAction() {
        onAction?()
    }
}
