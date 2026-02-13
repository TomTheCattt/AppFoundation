//
//  CaptionLabel.swift
//  BaseIOSApp
//
//  Caption/small text label using design system typography.
//

import UIKit

final class CaptionLabel: UILabel {

    var textStyle: TextStyle = DesignSystemTypography.caption1 {
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
        textColor = DesignSystemColors.textSecondary.uiColor
    }
}
