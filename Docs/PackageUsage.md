# Hướng Dẫn Sử Dụng BaseIOSApp Package

Tài liệu này hướng dẫn cách tích hợp và sử dụng **BaseIOSApp Package** vào các dự án con (Consumer Apps). Package này cung cấp nền tảng vững chắc, chuẩn hóa và tối ưu cho việc phát triển ứng dụng iOS.

## 1. Cài Đặt (Installation)

### Swift Package Manager (SPM)

1.  Mở dự án Xcode của bạn.
2.  Chọn **File > Add Packages...**
3.  Nhập URL của repository chứa BaseIOSApp Package.
4.  Chọn version mong muốn (khuyến nghị dùng Semantic Versioning, ví dụ: `Up to Next Major 1.0.0`).
5.  Chọn các products cần thiết cho target của bạn:
    -   `BaseIOSCore`: Bắt buộc. Chứa logic nền tảng.
    -   `BaseIOSResources`: Bắt buộc. Chứa assets và theme.
    -   `BaseIOSUI`: Khuyên dùng. Chứa UI Components và Base classes.
    -   `BaseIOSAuth`: Tùy chọn. Nếu dự án có chức năng đăng nhập/đăng ký.

---

## 2. Modules Chi Tiết

### A. BaseIOSCore (Nền Tảng)

Module này chứa logic cốt lõi, không phụ thuộc vào UI.

**Tính năng chính:**
-   **APIClient**: Gọi mạng thông minh (Smart Retry, Auto-pause).
-   **Logger**: Hệ thống log tập trung, hỗ trợ file log và console log.
-   **DIContainer**: Dependency Injection container (wrapper của Swinject).
-   **TokenStore**: Quản lý Token bảo mật trong Keychain.

**Ví dụ sử dụng:**

```swift
import BaseIOSCore

// 1. Khởi tạo (thường trong AppDelegate)
LifecycleManager.shared.bootstrap()

// 2. Gọi API
let client = APIClient()
let user = try await client.request(UserEndpoint.getProfile)

// 3. Log
Logger.shared.info("User logged in: \(user.id)")
```

### B. BaseIOSResources (Tài Nguyên)

Module quản lý tập trung tài nguyên (Ảnh, Màu, Font, String) và giao diện (Theme).

**Tính năng chính:**
-   **Theme System**: Cho phép override màu sắc/font của toàn bộ app.
-   **Assets**: Truy cập ảnh, icon chuẩn hóa.

**Ví dụ Override Theme (Trong App Con):**

```swift
import BaseIOSResources

struct MyAppTheme: ColorThemeProtocol {
    var primary: UIColor = .systemRed // Đổi màu chủ đạo thành Đỏ
    var background: UIColor = .white
    // ... implement các thuộc tính khác
}

// Trong AppDelegate
ThemeManager.shared.apply(colors: MyAppTheme())
```

### C. BaseIOSUI (Giao Diện)

Module chứa các UI Components và Base Classes.

**Tính năng chính:**
-   **BaseViewController**: Tự động xử lý Loading, Error, Keyboard.
-   **BaseViewModel**: Quản lý state (Idle, Loading, Error, Content).
-   **DesignSystem Components**: PrimaryButton, AppTextField, etc.

**Ví dụ sử dụng:**

```swift
import BaseIOSUI

class LoginViewController: BaseViewController<LoginViewModel> {
    override func setupBindings() {
        super.setupBindings()
        
        // Tự động hiện Loading Indicator khi viewModel.isLoading = true
        // Tự động hiện Alert khi viewModel.error != nil
    }
}
```

### D. BaseIOSAuth (Xác Thực)

Feature Module trọn gói cho chức năng Đăng nhập/Đăng ký.

**Tính năng chính:**
-   **Authentication Flow**: Login -> Save Token -> Auto Refresh -> Logout.
-   **UI Integration**: Cung cấp `LoginUseCase` để tích hợp vào ViewModel.

**Ví dụ sử dụng:**

```swift
import BaseIOSAuth

class LoginViewModel: BaseViewModel {
    private let useCase: LoginUseCaseProtocol
    
    func login() {
        Task {
            do {
                try await useCase.execute(email: "...", password: "...")
                // Thành công: Token đã được lưu, chuyển màn hình
            } catch {
                self.error = error
            }
        }
    }
}
```
