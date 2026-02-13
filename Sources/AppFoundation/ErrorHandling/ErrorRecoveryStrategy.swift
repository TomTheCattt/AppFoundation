//
//  ErrorRecoveryStrategy.swift
//  AppFoundation
//

import UIKit

protocol ErrorRecoveryStrategy {
    var actions: [RecoveryAction] { get }
}

struct RecoveryAction {
    let title: String
    let style: UIAlertAction.Style
    let handler: () -> Void
}

struct RetryStrategy: ErrorRecoveryStrategy {
    let retryAction: () async throws -> Void

    var actions: [RecoveryAction] {
        [
            RecoveryAction(title: "Retry", style: .default) {
                Task { try? await retryAction() }
            }
        ]
    }
}
