//
//  UIViewController+Extensions.swift
//  BaseIOSApp
//
//  UIViewController extensions for alerts, child VCs, and keyboard handling.
//

import UIKit

extension UIViewController {
    
    // MARK: - Basic Helpers
    
    /// Shows a simple alert with OK button
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - completion: Optional completion handler
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    /// Shows an alert with custom actions
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - actions: Array of alert actions
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    /// Hides keyboard when tapping outside text fields
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTap() {
        view.endEditing(true)
    }
    
    // MARK: - Advanced Helpers
    
    /// Adds a child view controller to a container view
    /// - Parameters:
    ///   - child: Child view controller to add
    ///   - containerView: Container view (defaults to parent's view)
    func addChild(_ child: UIViewController, to containerView: UIView? = nil) {
        let container = containerView ?? view!
        
        addChild(child)
        child.view.frame = container.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    /// Removes the view controller from its parent
    func removeFromParentVC() {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    /// Presents the view controller as a sheet (iOS 15+)
    /// - Parameters:
    ///   - viewController: View controller to present
    ///   - detents: Sheet detents (default: medium and large)
    ///   - animated: Whether to animate presentation
    @available(iOS 15.0, *)
    func presentAsSheet(_ viewController: UIViewController,
                       detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
                       animated: Bool = true) {
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = detents
            sheet.prefersGrabberVisible = true
        }
        present(viewController, animated: animated)
    }
    
    /// Shows a loading indicator
    /// - Returns: The activity indicator view (to be dismissed later)
    @discardableResult
    func showLoadingIndicator() -> UIView {
        let containerView = UIView(frame: view.bounds)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        containerView.tag = 999 // Tag for easy removal
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = containerView.center
        activityIndicator.startAnimating()
        
        containerView.addSubview(activityIndicator)
        view.addSubview(containerView)
        
        return containerView
    }
    
    /// Hides the loading indicator
    func hideLoadingIndicator() {
        view.subviews.first(where: { $0.tag == 999 })?.removeFromSuperview()
    }
}
