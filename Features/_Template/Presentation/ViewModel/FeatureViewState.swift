//
//  FeatureViewState.swift
//  BaseIOSApp
//

import Foundation

enum FeatureViewState: Equatable {
    case idle
    case loading
    case loaded([FeatureEntity])
    case error(Error)
    case empty

    static func == (lhs: FeatureViewState, rhs: FeatureViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.empty, .empty):
            return true
        case let (.loaded(l), .loaded(r)): return l == r
        case let (.error(e1), .error(e2)): return e1.localizedDescription == e2.localizedDescription
        default: return false
        }
    }
}

extension FeatureViewState {
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    var hasError: Bool {
        if case .error = self { return true }
        return false
    }
}
