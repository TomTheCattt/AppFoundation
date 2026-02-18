//
//  LoadingModifier.swift
//  AppFoundation
//
//  Overlay loading indicator on any view.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    var isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
                .allowsHitTesting(!isLoading)

            if isLoading {
                LoadingView()
            }
        }
    }
}

extension View {
    func loading(active: Bool) -> some View {
        modifier(LoadingModifier(isLoading: active))
    }
}
