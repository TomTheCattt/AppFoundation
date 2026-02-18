//
//  CardView.swift
//  AppFoundation
//
//  Simple card container with design system background and corner radius.
//

import UIKit

class CardView: BaseView {

    override func setupView() {
        super.setupView()
        backgroundColor = DesignSystemColors.backgroundSecondary.uiColor
        layer.cornerRadius = DesignSystemCornerRadius.md
        layer.masksToBounds = true
    }
}
