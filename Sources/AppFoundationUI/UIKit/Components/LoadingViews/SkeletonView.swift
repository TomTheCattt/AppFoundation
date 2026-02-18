//
//  SkeletonView.swift
//  AppFoundation
//
//  Skeleton placeholder view for loading states.
//

import UIKit

final class SkeletonView: UIView {

    private let gradientLayer = CAGradientLayer()
    private let animationKey = "shimmer"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = DesignSystemColors.backgroundSecondary.uiColor
        gradientLayer.colors = [
            DesignSystemColors.backgroundSecondary.uiColor.cgColor,
            DesignSystemColors.backgroundTertiary.uiColor.cgColor,
            DesignSystemColors.backgroundSecondary.uiColor.cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0, 0, 0]
        animation.toValue = [1, 1, 1]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: animationKey)
    }

    func stopAnimating() {
        gradientLayer.removeAnimation(forKey: animationKey)
    }
}
