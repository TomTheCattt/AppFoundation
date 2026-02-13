//
//  SwiftUISecondaryButton.swift
//  AppFoundation
//
//  SwiftUI secondary (outline) button.
//

import SwiftUI

struct SwiftUISecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystemSpacing.xs)
                .padding(.horizontal, DesignSystemSpacing.md)
                .foregroundColor(Color.primaryColor)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystemCornerRadius.sm)
                        .stroke(Color.primaryColor, lineWidth: DesignSystemBorderWidth.medium)
                )
        }
    }
}
