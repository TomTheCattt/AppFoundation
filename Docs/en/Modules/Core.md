# AppFoundation (Core) Module

This module contains the fundamental building blocks of your application.

## 1. Networking (`APIClient`)

Our `APIClient` wraps Alamofire and provides automatic retry, authentication handling, and simplified error management.

### Usage
```swift
import AppFoundation

// 1. Define Request (Implement Requestable)
struct FetchUserRequest: Requestable {
    let path = "/users/me"
    let method: HTTPMethod = .get
    let headerParameters: [String : String] = ["Connection": "keep-alive"]
    let isAuthenticationRequired: Bool = true // Critical: Triggers AuthInterceptor
}

// 2. Execute Request
let apiClient = APIClient.shared // Or inject via DI
let request = FetchUserRequest()

Task {
    do {
        let user: UserDTO = try await apiClient.request(request)
        print("User fetched: \(user.name)")
    } catch {
        print("Error: \(error)")
    }
}
```

### Features
-   **SmartRetrier**: Automatically retries 3 times on network failure or 500 errors.
-   **AuthInterceptor**: Automatically injects Bearer token if `isAuthenticationRequired` is true. Handles 401 and refreshes token silently.

## 2. Dependency Injection (`DIContainer`)

We use Swinject under the hood but expose a simplified `DIContainer`.

### Registering Dependencies
In your app startup:
```swift
let container = DIContainer.shared
container.register(AuthenticationUseCaseProtocol.self) { _ in
    AuthenticationUseCase(repository: AuthRepository())
}
```

### Resolving Dependencies
Usually done in Coordinators or ViewModels:
```swift
let authUseCase = DIContainer.shared.resolve(AuthenticationUseCaseProtocol.self)
```

## 3. Storage

### Secure Storage (Keychain)
```swift
let keychain = KeychainManager.standard
try keychain.save("secret-token", for: "auth_token")
let token = try keychain.read("auth_token")
```

### Disk Storage (Caching)
```swift
let storage = DiskStorage(path: "Cache")
try storage.save(userObject, for: "currentUser")
```

## 4. Biometrics
Enable FaceID/TouchID easily:
```swift
let biometricManager = BiometricManager()
if biometricManager.canEvaluatePolicy() {
    biometricManager.evaluatePolicy(reason: "Login to access account") { success, error in
        if success {
            // Unlocked!
        }
    }
}
```
