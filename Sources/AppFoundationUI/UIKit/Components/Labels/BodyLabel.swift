//
//  BodyLabel.swift
//  AppFoundation
//
//  Body text label using design system typography.
//

import UIKit

final class BodyLabel: UILabel {

    var textStyle: TextStyle = DesignSystemTypography.body {
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
        numberOfLines = 0
    }
}
