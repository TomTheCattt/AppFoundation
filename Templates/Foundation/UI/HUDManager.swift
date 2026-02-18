//
//  HUDManager.swift
//  {{PROJECT_NAME}}
//
//  Created by Project Factory.
//

import UIKit
import SwiftUI

/// Quản lý hiển thị Overlay/Toast trên một UIWindow riêng biệt ở cấp độ cao nhất (statusBar + 1).
/// Đảm bảo thông báo không bao giờ bị che khuất bởi Keyboard hay các Views khác.
public class HUDManager {
    
    public static let shared = HUDManager()
    
    private var window: UIWindow?
    
    private init() {
        setupWindow()
    }
    
    private func setupWindow() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let hudWindow = UIWindow(windowScene: windowScene)
            hudWindow.windowLevel = .statusBar + 1
            hudWindow.backgroundColor = .clear
            hudWindow.isUserInteractionEnabled = false // Cho phép chạm xuyên qua nếu không đang hiện loading
            self.window = hudWindow
        }
    }
    
    /// Hiển thị một Toast thông báo
    public func showToast(message: String, duration: TimeInterval = 2.0) {
        DispatchQueue.main.async {
            let toastView = self.createToastView(message: message)
            self.window?.rootViewController = UIViewController()
            self.window?.rootViewController?.view.addSubview(toastView)
            self.window?.isHidden = false
            
            // Animation hiện ra
            toastView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                toastView.alpha = 1
            }
            
            // Animation ẩn đi sau `duration`
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                UIView.animate(withDuration: 0.3, animations: {
                    toastView.alpha = 0
                }) { _ in
                    self.window?.isHidden = true
                    toastView.removeFromSuperview()
                }
            }
        }
    }
    
    private func createToastView(message: String) -> UIView {
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        let padding: CGFloat = 16
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView()
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -100),
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding)
        ])
        
        return label
    }
}
