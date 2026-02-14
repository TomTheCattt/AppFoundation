import SwiftUI

public struct iBankTextField: View {
    let placeholder: String
    @Binding var text: String
    let leftIcon: String?
    let rightIcon: String?
    let isSecure: Bool
    
    @FocusState private var isFocused: Bool
    
    public init(
        _ placeholder: String,
        text: Binding<String>,
        leftIcon: String? = nil,
        rightIcon: String? = nil,
        isSecure: Bool = false
    ) {
        self.placeholder = placeholder
        self._text = text
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.isSecure = isSecure
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            if let icon = leftIcon {
                Image(systemName: icon)
                    .foregroundColor(DesignSystemColors.neutral70.color)
                    .frame(width: 24, height: 24)
            }
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(DesignSystemTypography.body2.font.swiftUI)
            .focused($isFocused)
            
            if let icon = rightIcon {
                Image(systemName: icon)
                    .foregroundColor(DesignSystemColors.neutral70.color)
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(DesignSystemColors.white.color)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isFocused ? DesignSystemColors.primary.color : DesignSystemColors.neutral40.color,
                    lineWidth: 1
                )
        )
    }
}

private extension UIFont {
    var swiftUI: Font {
        Font(self as CTFont)
    }
}
