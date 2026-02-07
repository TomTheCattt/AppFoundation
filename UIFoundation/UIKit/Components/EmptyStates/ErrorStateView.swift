//
//  ErrorStateView.swift
//  BaseIOSApp
//
//  Error state with message and retry action.
//

import UIKit

final class ErrorStateView: EmptyStateView {

    override func setupView() {
        super.setupView()
        configure(
            image: UIImage(systemName: IconSet.Status.error),
            title: "Something went wrong",
            message: "Please try again.",
            actionTitle: "Retry"
        )
    }

    func configure(error: Error?, retryTitle: String = "Retry", onRetry: (() -> Void)?) {
        let message = error?.localizedDescription ?? "Please try again."
        super.configure(
            image: UIImage(systemName: IconSet.Status.error),
            title: "Something went wrong",
            message: message,
            actionTitle: retryTitle,
            onAction: onRetry
        )
    }
}
