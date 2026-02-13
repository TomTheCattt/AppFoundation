//
//  DynamicTypeSupport.swift
//  BaseIOSApp
//
//  Dynamic Type observation and scaled fonts.
//

import UIKit

final class DynamicTypeSupport {

    static func observeDynamicTypeChanges(
        in viewController: UIViewController,
        handler: @escaping () -> Void
    ) {
        NotificationCenter.default.addObserver(
            forName: UIContentSizeCategory.didChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            handler()
        }
    }

    static func scaledFont(
        _ font: UIFont,
        maximumPointSize: CGFloat? = nil
    ) -> UIFont {
        let metrics = UIFontMetrics.default
        if let maxSize = maximumPointSize {
            return metrics.scaledFont(for: font, maximumPointSize: maxSize)
        }
        return metrics.scaledFont(for: font)
    }
}

extension UILabel {
    func enableDynamicType(
        textStyle: UIFont.TextStyle,
        maximumPointSize: CGFloat? = nil
    ) {
        adjustsFontForContentSizeCategory = true
        if let maxSize = maximumPointSize {
            font = UIFontMetrics(forTextStyle: textStyle).scaledFont(
                for: font,
                maximumPointSize: maxSize
            )
        }
    }
}
