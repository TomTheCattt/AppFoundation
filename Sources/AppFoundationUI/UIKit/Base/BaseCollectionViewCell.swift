//
//  BaseCollectionViewCell.swift
//  AppFoundation
//
//  Base collection view cell. Override setupCell, configure(with:), onReuse to assign behaviour.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    // MARK: - Override points

    /// Setup cell UI (subviews, colors). Called once from init. Override to build layout.
    func setupCell() {
        backgroundColor = DesignSystemColors.background.uiColor
        contentView.backgroundColor = DesignSystemColors.background.uiColor
    }

    /// Configure cell with model. Override to bind data to views. Called from collectionView's cellForItem.
    func configure(with model: Any) {
        // Override in subclass
    }

    /// Called when cell is about to be reused. Override to reset state or cancel work.
    func onReuse() {}

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
    }
}
