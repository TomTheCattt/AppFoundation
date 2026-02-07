//
//  ProfileViewState.swift
//  BaseIOSApp
//

import Foundation

enum ProfileViewState: Equatable {
    case idle
    case loading
    case loaded(UserEntity)
    case error(Error)

    static func == (lhs: ProfileViewState, rhs: ProfileViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading): return true
        case let (.loaded(a), .loaded(b)): return a == b
        case let (.error(e1), .error(e2)): return e1.localizedDescription == e2.localizedDescription
        default: return false
        }
    }
}
