# AppFoundationAuth Module

Provides a complete, reusable authentication flow.

## Overview
This module includes:
-   **Login Screen**: Built-in `LoginViewController` with MVVM.
-   **Registration Screen**: Built-in `RegisterViewController`.
-   **Token Managment**: Secured by `KeychainManager`.

## Integration

Use the `AuthCoordinator` to launch the Auth flow.

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
            // Called when user successfully logs in
            self?.showHome()
        }
    }
}
```

## Customization

You can customize the login screen behavior via `AppFoundationResources` themes or by subclassing but reusing the ViewModels.

## Errors
`AuthError` handles common scenarios:
-   `.invalidCredentials`: Wrong email/pass
-   `.networkError`: No internet
-   `.serverError`: 500 error from backend
