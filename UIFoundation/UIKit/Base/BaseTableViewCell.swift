//
//  BaseTableViewCell.swift
//  BaseIOSApp
//
//  Base table view cell. Override setupCell, configure(with:), onReuse to assign behaviour.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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

    /// Configure cell with model. Override to bind data to views. Called from tableView's cellForRow.
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
