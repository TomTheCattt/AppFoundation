//
//  VoiceOverHelper.swift
//  BaseIOSApp
//
//  VoiceOver announcement and focus helpers.
//

import UIKit

final class VoiceOverHelper {

    static func isVoiceOverRunning() -> Bool {
        UIAccessibility.isVoiceOverRunning
    }

    static func announce(_ message: String) {
        UIAccessibility.post(notification: .announcement, argument: message)
    }

    static func focusOn(_ element: Any) {
        UIAccessibility.post(notification: .screenChanged, argument: element)
    }
}

extension UIView {
    func configureAccessibility(
        label: String,
        hint: String? = nil,
        traits: UIAccessibilityTraits = .none,
        identifier: String? = nil
    ) {
        isAccessibilityElement = true
        accessibilityLabel = label
        accessibilityHint = hint
        accessibilityTraits = traits
        if let identifier = identifier {
            accessibilityIdentifier = identifier
        }
    }
}
