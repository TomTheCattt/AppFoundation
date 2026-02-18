//
//  ErrorView.swift
//  AppFoundation
//
//  SwiftUI error state with retry.
//

import SwiftUI

struct ErrorView: View {
    var error: Error?
    var retryTitle: String = "Retry"
    var onRetry: (() -> Void)?

    var body: some View {
        SwiftUIEmptyStateView(
            imageName: IconSet.Status.error,
            title: "Something went wrong",
            message: error?.localizedDescription ?? "Please try again.",
            actionTitle: retryTitle,
            action: onRetry
        )
    }
}
