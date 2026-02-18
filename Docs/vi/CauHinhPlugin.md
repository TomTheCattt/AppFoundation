# Hướng Dẫn Cấu Hình Build Tool Plugins

Tài liệu này giải thích cách cấu hình plugins **SwiftLint** và **SwiftGen** khi bạn thêm AppFoundation vào dự án.

## Tổng Quan

AppFoundation cung cấp hai **SPM Build Tool Plugins**:
1. **SwiftLintPlugin** - Kiểm tra code style trong quá trình build
2. **SwiftGenPlugin** - Tự động sinh code type-safe từ assets

Các plugins này chạy tự động trong quá trình build, nhưng cần:
- Cài đặt tools trên hệ thống (`brew install swiftlint swiftgen`)
- File cấu hình trong **dự án của bạn** (không phải trong package AppFoundation)

---

## Cấu Hình SwiftLint

### 1. Cài Đặt SwiftLint

```bash
brew install swiftlint
```

### 2. Tạo `.swiftlint.yml` Ở Thư Mục Gốc Dự Án

SwiftLintPlugin sẽ tìm file `.swiftlint.yml` ở thư mục gốc dự án của bạn.

**Ví dụ `.swiftlint.yml`:**

```yaml
# Tắt các rules không muốn dùng
disabled_rules:
  - trailing_whitespace
  - line_length

# Bật các opt-in rules
opt_in_rules:
  - empty_count
  - closure_spacing

# Loại trừ files/folders
excluded:
  - Pods
  - .build
  - DerivedData

# Cấu hình rules cụ thể
line_length:
  warning: 120
  error: 200

identifier_name:
  min_length: 2
  max_length: 40
```

### 3. Kích Hoạt Plugin Trong Xcode

Khi thêm AppFoundation:
1. Xcode sẽ hỏi: "Do you want to enable SwiftLintPlugin?"
2. Click **Trust & Enable**

### 4. Kiểm Tra

Build dự án. Bạn sẽ thấy:
```
Running SwiftLint for YourTarget
```

Các cảnh báo/lỗi SwiftLint sẽ hiện trong Issue Navigator của Xcode.

---

## Cấu Hình SwiftGen

### 1. Cài Đặt SwiftGen

```bash
brew install swiftgen
```

### 2. Tạo `swiftgen.yml` Trong Dự Án

SwiftGen cần biết assets ở đâu và output code ra đâu.

**Ví dụ `swiftgen.yml`:**

```yaml
# Đặt file này ở thư mục gốc dự án
input_dir: .
output_dir: Generated

# Sinh code cho Assets.xcassets
xcassets:
  inputs:
    - YourApp/Assets.xcassets
  outputs:
    - templateName: swift5
      output: Generated/Assets.swift

# Sinh code cho Localizable.strings
strings:
  inputs:
    - YourApp/Resources/en.lproj
  outputs:
    - templateName: structured-swift5
      output: Generated/Strings.swift

# Sinh code cho Colors
colors:
  inputs:
    - YourApp/Colors.txt
  outputs:
    - templateName: swift5
      output: Generated/Colors.swift
```

### 3. Điều Chỉnh Đường Dẫn Cho Dự Án

Thay `YourApp` bằng tên target thực tế:
- `YourApp/Assets.xcassets` → Đường dẫn assets catalog của bạn
- `YourApp/Resources/en.lproj` → Đường dẫn localization files

### 4. Thêm Generated Files Vào Xcode

Sau khi SwiftGen chạy, thêm các file đã sinh vào Xcode:
1. Right-click dự án trong Navigator
2. Add Files to "YourProject"
3. Chọn `Generated/Assets.swift`, `Generated/Strings.swift`, etc.

### 5. Kích Hoạt Plugin

Khi thêm AppFoundation:
1. Xcode hỏi: "Do you want to enable SwiftGenPlugin?"
2. Click **Trust & Enable**

### 6. Kiểm Tra

Build dự án. Bạn sẽ thấy:
```
Running SwiftGen for YourTarget
```

Sử dụng code đã sinh:
```swift
// Thay vì:
UIImage(named: "logo")

// Dùng type-safe:
Asset.logo.image
```

---

## Hành Vi Plugin Trong AppFoundation Package

**Quan trọng**: Các plugins được cấu hình để hoạt động với **dự án của bạn**, không phải package AppFoundation.

- **SwiftLintPlugin**: Tìm `.swiftlint.yml` ở thư mục gốc dự án của bạn
- **SwiftGenPlugin**: Tìm `swiftgen.yml` ở thư mục gốc dự án của bạn

Nếu các file này không tồn tại:
- SwiftLint: Dùng rules mặc định
- SwiftGen: Bỏ qua việc sinh code (có cảnh báo)

---

## Xử Lý Lỗi

### "Command 'swiftlint' not found"

**Giải pháp**: Cài SwiftLint
```bash
brew install swiftlint
which swiftlint  # Kiểm tra đã cài
```

### "SwiftGen config not found"

**Giải pháp**: Tạo `swiftgen.yml` ở thư mục gốc dự án (xem ví dụ trên)

Hoặc tắt plugin nếu không cần:
- Project Settings → Build Phases → Xóa SwiftGenPlugin

### Plugin Không Chạy

1. Kiểm tra plugin đã enable:
   - Project Settings → Build Phases → Run Build Tool Plug-ins
2. Clean build folder: **Cmd+Shift+K**
3. Rebuild: **Cmd+B**

### SwiftLint Rules Quá Nghiêm

Sửa `.swiftlint.yml` để tắt rules cụ thể:
```yaml
disabled_rules:
  - line_length
  - force_cast
```

---

## Tắt Plugins

Nếu không muốn dùng plugins:

1. **Không enable** khi Xcode hỏi
2. Hoặc xóa khỏi Build Phases:
   - Project Settings → Build Phases
   - Xóa "Run SwiftLintPlugin" và "Run SwiftGenPlugin"

---

## Ví Dụ Cấu Trúc Dự Án

```
YourProject/
├── .swiftlint.yml          # Cấu hình SwiftLint
├── swiftgen.yml            # Cấu hình SwiftGen
├── YourApp/
│   ├── Assets.xcassets     # Assets của bạn
│   ├── Resources/
│   │   └── en.lproj/       # Localizations
│   └── ...
├── Generated/              # Output SwiftGen (gitignored)
│   ├── Assets.swift
│   └── Strings.swift
└── Package Dependencies/
    └── AppFoundation       # Package này
```

---

## Bước Tiếp Theo

- Xem [Hướng Dẫn Cài Đặt](CaiDat.md) để thêm AppFoundation
- Đọc [Hướng Dẫn Module Core](Modules/Core.md) để hiểu các tính năng
