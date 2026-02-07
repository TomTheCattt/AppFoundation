//
//  AuthViewState.swift
//  BaseIOSApp
//

import Foundation

enum AuthViewState: Equatable {
    case idle
    case loading
    case success
    case error(Error)

    static func == (lhs: AuthViewState, rhs: AuthViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.success, .success): return true
        case let (.error(e1), .error(e2)): return e1.localizedDescription == e2.localizedDescription
        default: return false
        }
    }
}
