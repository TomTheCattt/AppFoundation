//
//  CardModifier.swift
//  BaseIOSApp
//
//  Card-style modifier for SwiftUI views.
//

import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(DesignSystemSpacing.sm)
            .background(Color(DesignSystemColors.backgroundSecondary.uiColor))
            .cornerRadius(DesignSystemCornerRadius.md)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
}
