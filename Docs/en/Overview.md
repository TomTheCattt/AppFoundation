# AppFoundation Package Overview

**AppFoundation** is a comprehensive, modular Swift Package designed to serve as the scalable foundation for modern iOS applications. It provides standardized implementations for Networking, Storage, UI Components, and Authentication, allowing developers to focus on feature development.

## Architecture

The package is divided into specialized modules:

| Module | Description | Dependencies |
| :--- | :--- | :--- |
| **AppFoundation (Core)** | The heart of the package. Contains `APIClient`, `TokenStore`, `Logger`, and Dependency Injection. | generic dependencies (Alamofire, Swinject, Realm) |
| **AppFoundationUI** | Reusable UI components, `BaseViewController`, `BaseViewModel`, and Theme System. | `AppFoundation`, `AppFoundationResources`, `Kingfisher` |
| **AppFoundationAuth** | Complete Authentication feature (Login/Register flow, Session Management). | `AppFoundation`, `AppFoundationUI` |
| **AppFoundationResources** | Centralized assets, fonts, strings, and Theme definitions. | None |

## Installation

### Swift Package Manager (SPM)

1.  Open your Xcode project.
2.  Go to **File > Add Packages...**
3.  Enter the repository URL.
4.  Select the desired version (e.g., `Up to Next Major 1.0.0`).
5.  Select the products you need:
    *   `AppFoundation` (Required)
    *   `AppFoundationUI` (Recommended)
    *   `AppFoundationAuth` (Optional)

## Core Features

### 1. Smart Networking
Powered by `Alamofire`, our `APIClient` handles:
*   **Token Injection**: Automatically adds Bearer tokens to requests.
*   **Automatic Refresh**: Intercepts 401 errors and refreshes the session seamlessly.
*   **Smart Retry**: Retries failed requests on specific errors (500, timeout).

```swift
import AppFoundation

let client = APIClient()
let user = try await client.request(UserEndpoint.profile)
```

### 2. UI Foundation
Build consistent UIs faster with standard components:
*   **BaseViewController**: Handles Loading states, Errors, and Keyboard dismissal automatically.
*   **Theme Manager**: Switch between Light/Dark/Custom themes dynamically.

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
Drop-in solution for login flows:
*   **Full Flow**: Login -> Save Token -> Auto Refresh -> Logout.
*   **Use Cases**: `LoginUseCase`, `RegisterUseCase`.

```swift
import AppFoundationAuth

let authCoordinator = AuthCoordinator(navigationController: nav, container: container)
authCoordinator.start()
```

## Next Steps
*   [Core Documentation](Core/Networking.md)
*   [UI Documentation](UI/Components.md)
*   [Auth Documentation](Auth/Authentication.md)
