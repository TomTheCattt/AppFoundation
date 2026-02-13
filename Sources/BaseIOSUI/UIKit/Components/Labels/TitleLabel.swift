//
//  TitleLabel.swift
//  BaseIOSApp
//
//  Title-style label using design system typography.
//

import UIKit

final class TitleLabel: UILabel {

    var textStyle: TextStyle = DesignSystemTypography.title2 {
        didSet { applyStyle() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyStyle()
    }

    private func applyStyle() {
        font = textStyle.font
        textColor = DesignSystemColors.textPrimary.uiColor
    }
}
