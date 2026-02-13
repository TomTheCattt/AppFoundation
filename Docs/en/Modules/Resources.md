# AppFoundationResources Module

A centralized place for all shared assets, localization, and theming.

## 1. Asset Management

Always access bundle resources via `AppResources.bundle`. This ensures they load correctly whether you use SPM or dynamic frameworks.

### Loading Images
```swift
let image = UIImage(named: "logo", in: AppResources.bundle, compatibleWith: nil)
```

### Loading Localized Strings
```swift
let title = NSLocalizedString("home_title", bundle: AppResources.bundle, comment: "")
```

## 2. Theme System

We provide a powerful `ThemeManager` to let users switch appearances.

### Defining a Theme
Implement `FontThemeProtocol` and `ColorThemeProtocol`.

```swift
struct MyCustomTheme: Theme {
    var colors: ColorThemeProtocol = DarkColorTheme()
    var fonts: FontThemeProtocol = DefaultFontTheme()
}
```

### Applying a Theme
```swift
ThemeManager.shared.apply(theme: MyCustomTheme())
```

### Using Theme Colors/Fonts
Inside your ViewModels or ViewControllers:

```swift
label.font = ThemeManager.shared.theme.fonts.headline
label.textColor = ThemeManager.shared.theme.colors.primaryText
view.backgroundColor = ThemeManager.shared.theme.colors.background
```

This way, updating the theme instantly propagates to any new UI element drawing itself.
