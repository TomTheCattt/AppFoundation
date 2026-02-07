//
//  FeatureTableViewCell.swift
//  BaseIOSApp
//

import UIKit

final class FeatureTableViewCell: BaseTableViewCell {
    static let reuseIdentifier = "FeatureCell"

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = DesignSystemTypography.body.font
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.font = DesignSystemTypography.caption1.font
        l.textColor = DesignSystemColors.textSecondary.uiColor
        l.numberOfLines = 1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override func setupCell() {
        super.setupCell()
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    override func configure(with model: Any) {
        guard let entity = model as? FeatureEntity else { return }
        titleLabel.text = entity.displayTitle
        subtitleLabel.text = entity.description
    }
}
