import SwiftUI

public struct iBankCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    
    public init(padding: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(padding)
            .background(DesignSystemColors.white.color)
            .cornerRadius(16)
            .shadow(
                color: Color(UIColor(hex: "#3629B7", alpha: 0.07)),
                radius: 30 / 2, // SwiftUI radius is half of Figma blur
                x: 0,
                y: 4
            )
    }
}

// MARK: - Card Modifiers
public extension View {
    func iBankCardStyle(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(DesignSystemColors.white.color)
            .cornerRadius(16)
            .shadow(
                color: Color(UIColor(hex: "#3629B7", alpha: 0.07)),
                radius: 15,
                x: 0,
                y: 4
            )
    }
}
