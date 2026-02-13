//
//  SwiftUIPrimaryButton.swift
//  AppFoundation
//
//  SwiftUI primary button using design system.
//

import SwiftUI

struct SwiftUIPrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignSystemSpacing.xs)
            .padding(.horizontal, DesignSystemSpacing.md)
            .background(Color.primaryColor)
            .foregroundColor(.white)
            .cornerRadius(DesignSystemCornerRadius.sm)
        }
        .disabled(isLoading)
        .opacity(isLoading ? 0.8 : 1)
    }
}
