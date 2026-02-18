//
//  BaseViewModel.swift
//  {{PROJECT_NAME}}
//

import Foundation
import Combine

/// Lớp cơ sở cho mọi ViewModel, tích hợp sẵn ViewState quản lý trạng thái màn hình.
open class BaseViewModel: ObservableObject {
    
    @Published public var state: ViewState = .idle
    
    public init() {}
    
    /// Hiển thị thông báo Toast nhanh thông qua HUDManager.
    public func showToast(_ message: String) {
        HUDManager.shared.showToast(message: message)
    }
}
