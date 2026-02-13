//
//  ShadowCardView.swift
//  AppFoundation
//
//  Card with elevation shadow.
//

import UIKit

final class ShadowCardView: CardView {

    override func setupView() {
        super.setupView()
        backgroundColor = DesignSystemColors.background.uiColor
        DesignSystemShadows.elevation2.apply(to: layer)
    }
}
