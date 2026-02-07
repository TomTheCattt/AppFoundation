//
//  ShimmerModifier.swift
//  BaseIOSApp
//
//  Shimmer loading modifier for SwiftUI.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    var isActive: Bool

    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isActive {
                        LinearGradient(
                            colors: [
                                .clear,
                                .white.opacity(0.3),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    }
                }
            )
            .redacted(reason: isActive ? .placeholder : [])
    }
}

extension View {
    func shimmer(active: Bool = true) -> some View {
        modifier(ShimmerModifier(isActive: active))
    }
}
