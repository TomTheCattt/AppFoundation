# Module AppFoundation (Core)

Module này chứa các thành phần cốt lõi của ứng dụng.

## 1. Networking (`APIClient`)

`APIClient` của chúng tôi bọc Alamofire và cung cấp khả năng tự động thử lại (retry), xử lý xác thực, và quản lý lỗi đơn giản hóa.

### Cách dùng
```swift
import AppFoundation

// 1. Định nghĩa Request (Implement Requestable)
struct FetchUserRequest: Requestable {
    let path = "/users/me"
    let method: HTTPMethod = .get
    let headerParameters: [String : String] = ["Connection": "keep-alive"]
    let isAuthenticationRequired: Bool = true // Quan trọng: Kích hoạt AuthInterceptor
}

// 2. Thực thi Request
let apiClient = APIClient.shared // Hoặc inject qua DI
let request = FetchUserRequest()

Task {
    do {
        let user: UserDTO = try await apiClient.request(request)
        print("Đã lấy user: \(user.name)")
    } catch {
        print("Lỗi: \(error)")
    }
}
```

### Tính năng
-   **SmartRetrier**: Tự động thử lại 3 lần khi mất mạng hoặc gặp lỗi 500.
-   **AuthInterceptor**: Tự động chèn Bearer token nếu `isAuthenticationRequired` là true. Xử lý lỗi 401 và làm mới token (refresh) hoàn toàn trong suốt.

## 2. Dependency Injection (`DIContainer`)

Chúng tôi sử dụng Swinject bên dưới nhưng cung cấp `DIContainer` đơn giản hơn.

### Đăng ký Dependencies
Khi khởi động app:
```swift
let container = DIContainer.shared
container.register(AuthenticationUseCaseProtocol.self) { _ in
    AuthenticationUseCase(repository: AuthRepository())
}
```

### Lấy Dependencies (Resolve)
Thường dùng trong Coordinators hoặc ViewModels:
```swift
let authUseCase = DIContainer.shared.resolve(AuthenticationUseCaseProtocol.self)
```

## 3. Storage (Lưu trữ)

### Secure Storage (Keychain)
```swift
let keychain = KeychainManager.standard
try keychain.save("secret-token", for: "auth_token")
let token = try keychain.read("auth_token")
```

### Disk Storage (Caching file)
```swift
let storage = DiskStorage(path: "Cache")
try storage.save(userObject, for: "currentUser")
```

## 4. Biometrics (Sinh trắc học)
Kích hoạt FaceID/TouchID dễ dàng:
```swift
let biometricManager = BiometricManager()
if biometricManager.canEvaluatePolicy() {
    biometricManager.evaluatePolicy(reason: "Đăng nhập để xem thông tin") { success, error in
        if success {
            // Đã mở khóa!
        }
    }
}
```
