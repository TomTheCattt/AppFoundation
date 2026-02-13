# Các Tính Năng Nâng Cao (Advanced Features)

Tài liệu này mô tả chi tiết các cơ chế nâng cao được tích hợp sẵn trong BaseIOSApp Package nhằm tối ưu hóa trải nghiệm người dùng và developer.

---

## 1. Quản lý Vòng Đời Ứng Dụng (Lifecycle Management)

BaseIOSCore cung cấp `LifecycleManager` và `BaseAppDelegate` để chuẩn hóa quá trình khởi tạo và xử lý trạng thái App.

### Cơ chế hoạt động:

1.  **Bootstrap (Khởi động)**:
    -   Tự động khởi tạo các service theo thứ tự ưu tiên: `Logger` -> `Environment` -> `DI` -> `Database` -> `Network` -> `Auth`.
    -   Đảm bảo không module nào được gọi khi chưa sẵn sàng.

2.  **Background/Foreground Handling**:
    -   **Vào Background**:
        -   Tự động pause (đóng băng) các API request có độ ưu tiên thấp.
        -   Xóa bộ nhớ đệm hình ảnh (Kingfisher) để giảm Memory Footprint.
        -   Lưu trạng thái tạm thời (nếu cần).
    -   **Vào Foreground**:
        -   Tự động resume (tiếp tục) các API request.
        -   Kiểm tra tính hợp lệ của Token (nếu token sắp hết hạn -> refresh ngay).
        -   Đồng bộ lại cấu hình từ server (Remote Config).

### Cách sử dụng:

Dự án con chỉ cần kế thừa `BaseAppDelegate`:

```swift
import BaseIOSCore
import UIKit

@main
class AppDelegate: BaseAppDelegate {
    // Không cần viết thêm code bootstrap, đã được xử lý ở super class.
}
```

---

## 2. Smart Networking (Mạng Thông Minh)

`APIClient` không chỉ gọi API mà còn tự động xử lý các vấn đề mạng thường gặp.

### Tính năng:

1.  **Auto Retry (Tự động thử lại)**:
    -   Nếu request thất bại do lỗi mạng (Timeout, Mất kết nối, Server lỗi 5xx), hệ thống sẽ tự động thử lại tối đa **3 lần**.
    -   **Exponential Backoff**: Thời gian chờ giữa các lần thử tăng dần (1s, 2s, 4s) để tránh làm quá tải server/mạng.

2.  **Network Awareness (Nhận biết mạng)**:
    -   Nếu thiết bị mất mạng hoàn toàn, các request mới sẽ được đưa vào hàng đợi chờ (Queue).
    -   Ngay khi có mạng lại, các request trong hàng đợi sẽ tự động được thực thi.

### Lợi ích:
-   Người dùng không cần bấm nút "Thử lại" thủ công.
-   Trải nghiệm mượt mà khi đi qua vùng sóng yếu (thang máy, hầm).

---

## 3. Advanced Authentication Flow (Xác Thực Nâng Cao)

Quy trình xác thực được thiết kế chặt chẽ để đảm bảo bảo mật và trải nghiệm liên tục.

### Luồng xử lý:

1.  **Auto Login (Tự động đăng nhập)**:
    -   Khi mở App, `AuthManager` kiểm tra Token trong Keychain.
    -   Nếu có Token -> Verify với Server -> Vào thẳng màn hình chính.
    -   Nếu không có -> Vào màn hình Login.

2.  **Silent Refresh Token (Làm mới Token âm thầm)**:
    -   Khi Access Token hết hạn, API trả về lỗi `401 Unauthorized`.
    -   `AuthInterceptor` bắt được lỗi này trước khi trả về cho UI.
    -   Tự động gọi API `/refresh-token` để lấy Access Token mới.
    -   Nếu thành công: Lưu token mới và thực hiện lại request ban đầu.
    -   **Kết quả**: Người dùng vẫn sử dụng bình thường, không bị gián đoạn.

3.  **Force Logout (Đăng xuất bắt buộc)**:
    -   Nếu Refresh Token cũng hết hạn (hoặc bị thu hồi), hệ thống sẽ:
        -   Xóa toàn bộ Token và User Data.
        -   Bắn notification `SessionExpired`.
        -   `BaseAppDelegate` lắng nghe và tự động chuyển Root ViewController về màn hình Login.
