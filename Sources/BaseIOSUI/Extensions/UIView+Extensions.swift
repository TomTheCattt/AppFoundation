//
//  UIView+Extensions.swift
//  BaseIOSApp
//
//  Common UIView extensions for layout, styling, and animations.
//

import UIKit

extension UIView {
    
    // MARK: - Basic Helpers
    
    /// Adds multiple subviews at once
    /// - Parameter views: Array of views to add
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    /// Rounds specific corners of the view
    /// - Parameters:
    ///   - corners: Corners to round
    ///   - radius: Corner radius value
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    /// Adds a border to the view
    /// - Parameters:
    ///   - color: Border color
    ///   - width: Border width
    func addBorder(color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    /// Removes all subviews from the view
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Advanced Helpers
    
    /// Shakes the view horizontally (useful for error feedback)
    /// - Parameters:
    ///   - duration: Animation duration (default: 0.5)
    ///   - repeatCount: Number of shakes (default: 2)
    func shake(duration: TimeInterval = 0.5, repeatCount: Float = 2) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -2.5, 2.5, 0.0]
        animation.repeatCount = repeatCount
        layer.add(animation, forKey: "shake")
    }
    
    /// Pulses the view (scale animation)
    /// - Parameters:
    ///   - duration: Animation duration (default: 0.6)
    ///   - scale: Scale factor (default: 1.1)
    func pulse(duration: TimeInterval = 0.6, scale: CGFloat = 1.1) {
        UIView.animate(withDuration: duration / 2, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { _ in
            UIView.animate(withDuration: duration / 2) {
                self.transform = .identity
            }
        }
    }
    
    /// Fades in the view
    /// - Parameters:
    ///   - duration: Animation duration (default: 0.3)
    ///   - completion: Completion handler
    func fadeIn(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }) { _ in
            completion?()
        }
    }
    
    /// Fades out the view
    /// - Parameters:
    ///   - duration: Animation duration (default: 0.3)
    ///   - completion: Completion handler
    func fadeOut(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
            completion?()
        }
    }
    
    /// Captures the view as an image
    /// - Returns: UIImage snapshot of the view
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// Adds a gradient layer to the view
    /// - Parameters:
    ///   - colors: Array of gradient colors
    ///   - startPoint: Start point (default: top)
    ///   - endPoint: End point (default: bottom)
    func addGradient(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
