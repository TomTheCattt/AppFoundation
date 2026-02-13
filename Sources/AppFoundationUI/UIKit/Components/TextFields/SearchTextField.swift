//
//  SearchTextField.swift
//  AppFoundation
//
//  Text field styled for search with magnifying glass icon.
//

import UIKit

final class SearchTextField: StandardTextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSearchStyle()
    }

    convenience init(placeholder: String = "Search") {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }

    private func setupSearchStyle() {
        leftView = nil
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = DesignSystemColors.textSecondary.uiColor
        iconView.contentMode = .center
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        iconView.frame = container.bounds
        container.addSubview(iconView)
        leftView = container
        leftViewMode = .always
        returnKeyType = .search
        accessibilityIdentifier = AccessibilityIdentifier.TextField.search
    }
}
