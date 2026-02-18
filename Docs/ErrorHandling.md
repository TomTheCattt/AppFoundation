# Xử Lý Lỗi Linh Hoạt (Flexible Error Handling)

Hệ thống xử lý lỗi của BaseIOSApp được thiết kế để tách biệt hai nhiệm vụ:
1.  **Hiển thị (UI)**: Alert, Toast, Banner... (Do App con quyết định).
2.  **Luồng nghiệp vụ (Flow)**: Logout, Maintenance, Force Update... (Do Base xử lý logic, App con hiển thị).

---

## 1. Hiển thị Lỗi (Error Display)

Base cung cấp protocol `ErrorDisplayProtocol` để App con có thể thay thế toàn bộ giao diện báo lỗi mặc định.

### Protocol:

```swift
public protocol ErrorDisplayProtocol {
    func showError(_ error: Error, in viewController: UIViewController, retryAction: (() -> Void)?)
}
```

### Cách Custom Giao diện:

Mặc định Base dùng `AlertErrorDisplay` (hiển thị UIAlertController). Nếu bạn muốn dùng **Toast** hoặc **Notification Banner**:

1.  **Tạo class implementation mới**:
    ```swift
    class ToastErrorDisplay: ErrorDisplayProtocol {
        func showError(_ error: Error, in viewController: UIViewController, retryAction: (() -> Void)?) {
            Toast.show(message: error.localizedDescription)
            // Handle retry button if needed...
        }
    }
    ```

2.  **Inject vào App**:
    ```swift
    // Trong AppDelegate
    DIContainer.shared.register(ErrorDisplayProtocol.self) { _ in 
        ToastErrorDisplay() 
    }
    ```

--> **Kết quả**: Tất cả màn hình (`BaseViewController`) sẽ tự động chuyển sang dùng Toast báo lỗi.

---

## 2. Xử Lý Luồng Lỗi (Error Logic Flow)

Một số lỗi đặc biệt cần chặn lại và xử lý trước khi hiển thị cho người dùng (hoặc hiển thị màn hình riêng biệt).

Chúng tôi sử dụng mô hình **Global Error Processor** (Chain of Responsibility).

### Cơ chế hoạt động:

Khi API trả về lỗi, nó đi qua chuỗi xử lý:

`APIClient` -> `ErrorProcessor` -> `ViewModel` -> `View`

### Các Processor tích hợp sẵn:

1.  **sessionExpired**: (401) -> Trigger flow Refresh Token (đã nói ở phần Auth).
2.  **maintenanceMode**: (503) -> Hiển thị màn hình "Bảo trì hệ thống" full screen.
3.  **forceUpdate**: (426) -> Hiển thị màn hình "Yêu cầu cập nhật App".

### Cách thêm Processor mới:

Nếu dự án con cần xử lý lỗi riêng (VD: Tài khoản bị khóa 5002):

```swift
class AccountLockedProcessor: ErrorProcesing {
    func process(error: Error) -> Error? {
        if let apiError = error as? APIError, apiError.code == 5002 {
            // Chuyển hướng sang màn hình CSKH
            AppNavigator.shared.showContactSupport()
            return nil // Đã xử lý xong, không báo lỗi UI nữa
        }
        return error // Tiếp tục đẩy lỗi xuống processor tiếp theo
    }
}
```
