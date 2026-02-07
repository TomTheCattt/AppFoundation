# BaseIOSApp – Architecture

- **Pragmatic Clean + MVVM + Dependency Injection (Swinject)**
- **UI:** UIKit (Storyboard) + SwiftUI
- **Target:** iOS 15.0+

## Layers

1. **App** – Application, Configuration, DI bootstrap
2. **Core** – Network, Storage, Security, Logging, Error handling, Performance
3. **Features** – Added in Phase 3+

## Phase 1 Scope

Foundation core: DI, Logger, Error handling, APIClient, Database abstraction, Keychain, Mock server support.
