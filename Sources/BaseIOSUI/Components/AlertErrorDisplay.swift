//
//  AlertErrorDisplay.swift
//  BaseIOSUI
//
//  Created by BaseIOSApp Package.
//

import UIKit

public protocol ErrorDisplayProtocol {
    func showError(_ error: Error, in viewController: UIViewController, retryAction: (() -> Void)?)
}

public struct AlertErrorDisplay: ErrorDisplayProtocol {
    public init() {}
    
    public func showError(_ error: Error, in viewController: UIViewController, retryAction: (() -> Void)?) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let retry = retryAction {
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                retry()
            })
        }
        
        viewController.present(alert, animated: true)
    }
}
