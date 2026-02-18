# Module AppFoundationResources

Nơi tập trung tất cả tài nguyên (assets), chuỗi đa ngôn ngữ (localization) và giao diện (theming).

## 1. Quản lý Tài nguyên (Assets)

Luôn truy cập tài nguyên bundle thông qua `AppResources.bundle`. Điều này đảm bảo chúng được load chính xác bất kể bạn dùng SPM hay dynamic frameworks.

### Load Ảnh
```swift
let image = UIImage(named: "logo", in: AppResources.bundle, compatibleWith: nil)
```

### Load Chuỗi Đa ngôn ngữ
```swift
let title = NSLocalizedString("home_title", bundle: AppResources.bundle, comment: "")
```

## 2. Hệ thống Theme (Giao diện)

Chúng tôi cung cấp `ThemeManager` mạnh mẽ để người dùng đổi giao diện.

### Định nghĩa Theme
Implement `FontThemeProtocol` và `ColorThemeProtocol`.

```swift
struct MyCustomTheme: Theme {
    var colors: ColorThemeProtocol = DarkColorTheme()
    var fonts: FontThemeProtocol = DefaultFontTheme()
}
```

### Áp dụng Theme
```swift
ThemeManager.shared.apply(theme: MyCustomTheme())
```

### Sử dụng Màu/Font của Theme
Trong ViewModels hoặc ViewControllers:

```swift
label.font = ThemeManager.shared.theme.fonts.headline
label.textColor = ThemeManager.shared.theme.colors.primaryText
view.backgroundColor = ThemeManager.shared.theme.colors.background
```

Bằng cách này, khi đổi theme, giao diện sẽ tự động cập nhật ngay lập tức.
