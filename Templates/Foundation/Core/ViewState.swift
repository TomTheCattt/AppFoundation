//
//  ViewState.swift
//  {{PROJECT_NAME}}
//

import Foundation

/// Các trạng thái phổ biến của một màn hình hoặc một tác vụ.
public enum ViewState: Equatable {
    case idle
    case loading
    case success
    case error(message: String)
    case empty(message: String)
    
    public static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.success, .success):
            return true
        case (.error(let a), .error(let b)), (.empty(let a), .empty(let b)):
            return a == b
        default:
            return false
        }
    }
}
