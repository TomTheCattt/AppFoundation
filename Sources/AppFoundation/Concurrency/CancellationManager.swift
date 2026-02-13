//
//  CancellationManager.swift
//  AppFoundation
//

import Foundation
import Combine

final class CancellationManager {
    private var cancellables = Set<AnyCancellable>()

    func register(_ cancellable: AnyCancellable) {
        cancellables.insert(cancellable)
    }

    func cancelAll() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    deinit {
        cancelAll()
    }
}
