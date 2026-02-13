//
//  DefaultLoadingView.swift
//  BaseIOSUI
//
//  Created by BaseIOSApp Package.
//

import UIKit

public final class DefaultLoadingView {
    public static let shared = DefaultLoadingView()
    
    private var containerView: UIView?
    private var activityIndicator: UIActivityIndicatorView?
    
    public func show(in view: UIView) {
        guard containerView == nil else { return }
        
        let container = UIView(frame: view.bounds)
        container.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = container.center
        indicator.startAnimating()
        
        container.addSubview(indicator)
        view.addSubview(container)
        
        self.containerView = container
        self.activityIndicator = indicator
    }
    
    public func hide() {
        activityIndicator?.stopAnimating()
        containerView?.removeFromSuperview()
        containerView = nil
        activityIndicator = nil
    }
}
