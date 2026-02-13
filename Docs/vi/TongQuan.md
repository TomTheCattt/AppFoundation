# Tổng Quan Về AppFoundation Package

**AppFoundation** là một Swift Package toàn diện, được thiết kế theo dạng module để làm nền tảng mở rộng cho các ứng dụng iOS hiện đại. Package cung cấp các triển khai chuẩn hóa cho Networking, Storage, UI Components và Authentication, giúp lập trình viên tập trung vào phát triển tính năng.

## Kiến Trúc

Package được chia thành các module chuyên biệt:

| Module | Mô tả | Dependencies |
| :--- | :--- | :--- |
| **AppFoundation (Core)** | Trái tim của package. Chứa `APIClient`, `TokenStore`, `Logger` và Dependency Injection. | generic dependencies (Alamofire, Swinject, Realm) |
| **AppFoundationUI** | UI components tái sử dụng, `BaseViewController`, `BaseViewModel` và hệ thống Theme. | `AppFoundation`, `AppFoundationResources`, `Kingfisher` |
| **AppFoundationAuth** | Tính năng xác thực trọn gói (Luồng Login/Register, Quản lý phiên). | `AppFoundation`, `AppFoundationUI` |
| **AppFoundationResources** | Tài nguyên tập trung (Assets, fonts, strings) và định nghĩa Theme. | Không có |

## Cài Đặt

### Swift Package Manager (SPM)

1.  Mở dự án Xcode của bạn.
2.  Vào **File > Add Packages...**
3.  Nhập URL của repository.
4.  Chọn phiên bản mong muốn (ví dụ: `Up to Next Major 1.0.0`).
5.  Chọn các products bạn cần:
    *   `AppFoundation` (Bắt buộc)
    *   `AppFoundationUI` (Khuyên dùng)
    *   `AppFoundationAuth` (Tùy chọn)

## Tính Năng Cốt Lõi

### 1. Smart Networking
Sử dụng `Alamofire`, `APIClient` của chúng tôi xử lý:
*   **Token Injection**: Tự động thêm Bearer token vào request.
*   **Automatic Refresh**: Bắt lỗi 401 và làm mới phiên làm việc mượt mà.
*   **Smart Retry**: Thử lại request thất bại với các lỗi cụ thể (500, timeout).

```swift
import AppFoundation

let client = APIClient()
let user = try await client.request(UserEndpoint.profile)
```

### 2. UI Foundation
Xây dựng giao diện nhất quán nhanh hơn với các component chuẩn:
*   **BaseViewController**: Tự động xử lý trạng thái Loading, Errors và ẩn bàn phím.
*   **Theme Manager**: Chuyển đổi giữa các theme Light/Dark/Custom động.

```swift
import AppFoundationUI

class MyViewController: BaseViewController<MyViewModel> {
    override func setupUI() {
        super.setupUI()
        // ...
    }
}
```

### 3. Modular Authentication
Giải pháp "drop-in" cho luồng đăng nhập:
*   **Full Flow**: Login -> Lưu Token -> Auto Refresh -> Logout.
*   **Use Cases**: `LoginUseCase`, `RegisterUseCase`.

```swift
import AppFoundationAuth

let authCoordinator = AuthCoordinator(navigationController: nav, container: container)
authCoordinator.start()
```

## Các Bước Tiếp Theo
*   [Tài Liệu Core](Core/Networking.md)
*   [Tài Liệu UI](UI/Components.md)
*   [Tài Liệu Auth](Auth/Authentication.md)
