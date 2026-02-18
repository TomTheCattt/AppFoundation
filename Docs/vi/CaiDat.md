# Hướng Dẫn Cài Đặt

AppFoundation được thiết kế dưới dạng một **Swift Package** theo hướng module hóa. Bạn có thể tích hợp vào dự án iOS bằng **Swift Package Manager (SPM)**.

## Yêu cầu hệ thống
- Xcode 15.0+
- iOS 15.0+
- Swift 5.9+

## Cách 1: Thêm vào dự án mới (Khuyên dùng)

1.  **Mở Xcode** và tạo dự án App hoặc vào dự án có sẵn.
2.  Vào **File > Add Package Dependencies...**
3.  Nhập URL của repository này (hoặc đường dẫn thư mục `file:///...` nếu đang phát triển local):
    *   `https://github.com/YourOrg/AppFoundation.git`
    *   *Hoặc kéo thả thư mục `AppFoundation` từ Finder vào dự án của bạn.*

4.  **Chọn Modules**:
    *   **AppFoundation** (Bắt buộc): Logic cốt lõi, Networking, Storage.
    *   **AppFoundationUI** (Tùy chọn): UI Components, Base ViewControllers.
    *   **AppFoundationAuth** (Tùy chọn): Luồng đăng nhập/đăng ký có sẵn.
    *   **AppFoundationResources** (Bắt buộc): Tài nguyên dùng chung (Ảnh, Theme).

## Cách 2: Phát triển Package độc lập

Nếu bạn muốn đóng góp code cho `AppFoundation` hoặc chạy thử `AppFoundationExample`:

1.  **Mở Package.swift**: Click đúp vào file `Package.swift` ở thư mục gốc. Xcode sẽ mở nó dưới dạng package.
2.  **Chọn Target**: Chọn scheme `AppFoundationExample`.
3.  **Chạy**: Chọn Simulator (ví dụ iPhone 16) và nhấn **Cmd+R**.

## Cách 3: Sinh file `.xcodeproj` (Nâng cao)

Nếu bạn cần file `.xcodeproj` truyền thống (ví dụ để quản lý build settings phức tạp), chúng tôi dùng **XcodeGen**:

1.  **Cài đặt XcodeGen**:
    ```bash
    brew install xcodegen
    ```
2.  **Sinh Project**:
    Chạy lệnh sau ở thư mục gốc:
    ```bash
    xcodegen generate
    ```
3.  **Mở**: Mở file `AppFoundation.xcodeproj` vừa tạo.

---

## Cấu hình sau khi cài đặt

Trong `AppDelegate.swift` hoặc `SceneDelegate.swift` của bạn:

```swift
import AppFoundation
import AppFoundationResources

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // 1. Khởi tạo các dịch vụ Core (Logging, DI)
    AppEnvironment.bootstrap() 
    
    // 2. Cấu hình Theme (Giao diện)
    ThemeManager.shared.apply(theme: DefaultTheme())
    
    return true
}
```

---

## Cài Đặt Build Tools (Tùy chọn nhưng khuyên dùng)

AppFoundation bao gồm **SPM Build Tool Plugins** cho **SwiftLint** và **SwiftGen** để đảm bảo chất lượng code và tự động sinh code từ assets.

### Cài đặt Build Tools

Các công cụ này phải được cài đặt trên hệ thống để plugins hoạt động:

```bash
# Cài qua Homebrew (Khuyên dùng)
brew install swiftlint swiftgen

# Hoặc qua Mint
mint install realm/SwiftLint
mint install swiftgen/swiftgen
```

> **📖 Hướng Dẫn Cấu Hình Chi Tiết**: Xem [Hướng Dẫn Cấu Hình Plugin](CauHinhPlugin.md) để biết cách setup đầy đủ bao gồm ví dụ `.swiftlint.yml` và `swiftgen.yml`.

### Kích hoạt Plugins trong Dự án

Khi thêm AppFoundation vào dự án, Xcode sẽ hỏi bạn có muốn kích hoạt build tool plugins không:

1. **SwiftLintPlugin**: Chạy SwiftLint trong quá trình build để kiểm tra code style
2. **SwiftGenPlugin**: Tự động sinh code type-safe cho assets

**Để kích hoạt:**
- Click **Trust & Enable** khi Xcode hiện thông báo
- Hoặc kích hoạt thủ công: Project Settings → Build Phases → Run Build Tool Plug-ins

### Kiểm tra Plugin đã cài đặt

Sau khi kích hoạt, build dự án. Bạn sẽ thấy:
```
Running SwiftLint for YourTarget
Running SwiftGen for YourTarget
```

### Xử lý Lỗi

**"Command 'swiftlint' not found"**
- Kiểm tra SwiftLint đã cài: `which swiftlint`
- Nếu chưa có, cài qua Homebrew: `brew install swiftlint`

**"SwiftGen config not found"**
- Đây là bình thường nếu bạn không dùng module `AppFoundationResources`
- Plugin sẽ tự động bỏ qua việc sinh code

**Tắt Plugins**
Nếu không muốn dùng plugins:
- Project Settings → Build Phases → Xóa các plugin entries
- Hoặc không kích hoạt khi Xcode hỏi

---

## Bước Tiếp Theo

- Đọc [Hướng Dẫn Module Core](Modules/Core.md) để hiểu về networking và DI
- Xem [Hướng Dẫn Module UI](Modules/UI.md) cho các component cơ sở
- Khám phá [Hướng Dẫn Module Auth](Modules/Auth.md) cho luồng xác thực
