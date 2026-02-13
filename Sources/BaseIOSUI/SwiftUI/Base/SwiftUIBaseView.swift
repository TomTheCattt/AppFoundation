//
//  SwiftUIBaseView.swift
//  BaseIOSApp
//
//  Base SwiftUI view with optional loading and error overlay.
//

import SwiftUI

struct SwiftUIBaseView<Content: View>: View {
    let content: Content
    var isLoading: Bool = false
    var error: Error? = nil
    var onRetry: (() -> Void)? = nil

    init(
        isLoading: Bool = false,
        error: Error? = nil,
        onRetry: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.isLoading = isLoading
        self.error = error
        self.onRetry = onRetry
        self.content = content()
    }

    var body: some View {
        ZStack {
            content

            if isLoading {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                ProgressView()
                    .scaleEffect(1.5)
            }

            if let error = error {
                VStack(spacing: 16) {
                    Text(error.localizedDescription)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.errorColor)
                    if onRetry != nil {
                        Button("Retry", action: { onRetry?() })
                    }
                }
                .padding()
            }
        }
    }
}
