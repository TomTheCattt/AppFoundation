import SwiftUI

// MARK: - Button Style
public struct iBankButtonStyle: ButtonStyle {
    public enum Variant {
        case primary
        case ghost
        case round
    }
    
    let variant: Variant
    let isDisabled: Bool
    
    public init(variant: Variant, isDisabled: Bool = false) {
        self.variant = variant
        self.isDisabled = isDisabled
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DesignSystemTypography.body1.font.swiftUI)
            .padding(.horizontal, variant == .round ? 0 : 24)
            .padding(.vertical, variant == .round ? 0 : 12)
            .frame(height: 44)
            .frame(maxWidth: variant == .round ? 44 : .infinity)
            .background(backgroundColor(configuration.isPressed))
            .foregroundColor(foregroundColor())
            .cornerRadius(variant == .round ? 22 : (variant == .primary ? 22 : 0))
            .opacity(isDisabled ? 0.5 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
    
    private func backgroundColor(_ isPressed: Bool) -> Color {
        switch variant {
        case .primary, .round:
            return isPressed ? DesignSystemColors.primary80.color : DesignSystemColors.primary.color
        case .ghost:
            return Color.clear
        }
    }
    
    private func foregroundColor() -> Color {
        switch variant {
        case .primary, .round:
            return DesignSystemColors.white.color
        case .ghost:
            return DesignSystemColors.error.color
        }
    }
}

// MARK: - Convenience Components
public struct iBankButton: View {
    let title: String
    let icon: String?
    let isDisabled: Bool
    let action: () -> Void
    
    public init(
        _ title: String,
        icon: String? = nil,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isDisabled = isDisabled
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
        }
        .buttonStyle(iBankButtonStyle(variant: .primary, isDisabled: isDisabled))
        .disabled(isDisabled)
    }
}

public struct iBankGhostButton: View {
    let title: String
    let action: () -> Void
    
    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .underline()
        }
        .buttonStyle(iBankButtonStyle(variant: .ghost))
    }
}

public struct iBankRoundButton: View {
    let icon: String
    let action: () -> Void
    
    public init(icon: String, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
        }
        .buttonStyle(iBankButtonStyle(variant: .round))
    }
}

// MARK: - Extension for easier access to SwiftUI font
private extension UIFont {
    var swiftUI: Font {
        Font(self as CTFont)
    }
}
