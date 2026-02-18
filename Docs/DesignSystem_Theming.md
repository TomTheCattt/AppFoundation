# Adaptive Design System & Theming

AppFoundation provides a robust, code-based Design System that natively supports **Light and Dark modes** without the overhead of complex Asset Catalogs or build-time code generation for core tokens.

## 🎨 Color System

The color system is built on **Adaptive Tokens**. Instead of hardcoding colors, we use dynamic initializers that respond to the system's `userInterfaceStyle`.

### 1. The `UIColor.dynamic` Helper
Located in `Foundation/Extensions/UIColor+Hex.swift`, this helper allows you to define a single color that automatically switches.

```swift
// Example usage in code
let brandColor = UIColor.dynamic(light: "#007AFF", dark: "#0A84FF")
```

### 2. Standardized Tokens
Core colors are defined in `DesignSystemColors` (found in `Foundation/UI/DesignSystem/Tokens/Colors.swift`).

| Token | Description | Adaptation Strategy |
| :--- | :--- | :--- |
| `brandPrimary` | The main brand color | Dynamic Hex (Light/Dark) |
| `brandSecondary` | Accent brand color | Dynamic Hex (Light/Dark) |
| `appBackground` | Main view background | Maps to `.systemBackground` |
| `appTextPrimary` | Standard label color | Maps to `.label` |
| `statusSuccess` | Semantic success color | Maps to `.systemGreen` |
| `statusError` | Semantic error color | Maps to `.systemRed` |

### 3. Usage in SwiftUI
All tokens are exposed as SwiftUI `Color` properties for seamless integration.

```swift
Text("Hello World")
    .foregroundColor(DesignSystemColors.appTextPrimary)
    .background(DesignSystemColors.appBackground)
```

## 🔡 Typography

Typography is centralized in `DesignSystemTypography.swift`. It supports multiple font families and predefined text styles.

### Standard Styles:
- `title1`, `title2`, `title3`
- `body1`, `body2` (Regular/Medium)
- `caption1`, `caption2`

### Example Usage:
```swift
Text("Welcome")
    .font(.title1) // Using custom extension
```

## 🌓 Switching Themes

The system relies on iOS native trait collections. 
- **Auto**: Follows system settings.
- **Manual**: Use `ThemeManager` (if included in your build) to override the `window.overrideUserInterfaceStyle`.

## 🛠 Customizing the Theme

To update the brand colors for a new project:
1. Open `Foundation/UI/DesignSystem/Tokens/Colors.swift`.
2. Update the hex strings in `brandPrimaryUIColor` and `brandSecondaryUIColor`.
3. The rest of the app will automatically inherit these new brand colors while maintaining system-standard accessibility for text and backgrounds.
