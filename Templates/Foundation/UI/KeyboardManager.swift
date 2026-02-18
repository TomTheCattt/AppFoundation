//
//  KeyboardManager.swift
//  {{PROJECT_NAME}}
//
//  Created by Project Factory.
//

import UIKit

/// Hỗ trợ tự động cuộn UIScrollView để tránh bàn phím che lấp UITextField/UITextView đang hoạt động.
public class KeyboardManager {
    
    public static let shared = KeyboardManager()
    
    private init() {}
    
    /// Đăng ký lắng nghe sự kiện bàn phím cho một ScrollView
    public func register(scrollView: UIScrollView, in viewController: UIViewController) {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            let contentInsets = UIEdgeInsets.zero
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    /// Thêm cử chỉ chạm ra ngoài để ẩn bàn phím
    public func addTapToDismiss(to view: UIView) {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
