//
//  BaseNavigationController.swift
//  AppFoundation
//
//  Base navigation controller with design system bar styling.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = DesignSystemColors.background.uiColor
            appearance.titleTextAttributes = DesignSystemTypography.title3.attributes()

            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
        } else {
            navigationBar.barTintColor = DesignSystemColors.background.uiColor
            navigationBar.titleTextAttributes = DesignSystemTypography.title3.attributes() as [NSAttributedString.Key: Any]
        }

        navigationBar.tintColor = DesignSystemColors.primary.uiColor
        navigationBar.isTranslucent = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        topViewController?.preferredStatusBarStyle ?? .default
    }
}
