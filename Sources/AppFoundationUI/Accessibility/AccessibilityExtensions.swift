//
//  AccessibilityExtensions.swift
//  AppFoundation
//
//  UIViewController and UIView accessibility extensions.
//

import UIKit

extension UIViewController {
    func setAccessibilityScreenLabel(_ label: String) {
        view.accessibilityLabel = label
        view.isAccessibilityElement = true
    }
}
