//
//  SwiftUIEmptyStateView.swift
//  AppFoundation
//
//  SwiftUI empty state with optional action.
//

import SwiftUI

struct SwiftUIEmptyStateView: View {
    var imageName: String = IconSet.Content.empty
    var title: String
    var message: String? = nil
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: DesignSystemSpacing.md) {
            Image(systemName: imageName)
                .font(.system(size: 60))
                .foregroundColor(Color(DesignSystemColors.textTertiary.uiColor))

            Text(title)
                .font(Font(DesignSystemTypography.title3.font as CTFont))
                .foregroundColor(Color(DesignSystemColors.textPrimary.uiColor))
                .multilineTextAlignment(.center)

            if let message = message, !message.isEmpty {
                Text(message)
                    .font(Font(DesignSystemTypography.body.font as CTFont))
                    .foregroundColor(Color(DesignSystemColors.textSecondary.uiColor))
                    .multilineTextAlignment(.center)
            }

            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .tint(Color(DesignSystemColors.primary.uiColor))
            }
        }
        .padding()
    }
}
