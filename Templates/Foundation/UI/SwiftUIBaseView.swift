//
//  BaseView.swift
//  {{PROJECT_NAME}}
//

import SwiftUI

/// View cơ sở cho SwiftUI, tự động quan sát ViewState và hiển thị HUD/Loading phù hợp.
public struct BaseView<Content: View>: View {
    @ObservedObject var viewModel: BaseViewModel
    let content: Content
    
    public init(viewModel: BaseViewModel, @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            content
            
            if case .loading = viewModel.state {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
        }
    }
}
