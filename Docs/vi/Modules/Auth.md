# Module AppFoundationAuth

Cung cấp luồng xác thực (Authentication) hoàn chỉnh và có thể tái sử dụng.

## Tổng Quan
Module này bao gồm:
-   **Màn hình Login**: `LoginViewController` tích hợp sẵn MVVM.
-   **Màn hình Register**: `RegisterViewController`.
-   **Quản lý Token**: Bảo mật bằng `KeychainManager`.

## Tích hợp (Integration)

Sử dụng `AuthCoordinator` để khởi chạy luồng Auth.

```swift
import AppFoundationAuth
import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    func start() {
        if AuthService.shared.isLoggedIn {
            showHome()
        } else {
            showAuth()
        }
    }
    
    func showAuth() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.start { [weak self] in
            // Gọi khi user đăng nhập thành công
            self?.showHome()
        }
    }
}
```

## Tùy biến (Customization)

Bạn có thể tùy biến giao diện màn hình đăng nhập thông qua Theme (`AppFoundationResources`) hoặc thừa kế lại ViewModel để dùng logic có sẵn nhưng thay đổi hoàn toàn UI.

## Xử lý Lỗi
`AuthError` xử lý các tình huống phổ biến:
-   `.invalidCredentials`: Sai email/mật khẩu.
-   `.networkError`: Không có mạng.
-   `.serverError`: Lỗi 500 từ server.
