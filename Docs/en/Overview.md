# AppFoundation Package Overview

**AppFoundation** is a comprehensive, modular Scaffolding System designed as a scalable foundation for modern iOS applications. It provides standardized, **truly generic** implementations for Networking, Storage, UI Components, and Authentication.

## Architecture

The package is divided into specialized modules, now purged of any project-specific logic:

| Module | Description | Dependencies |
| :--- | :--- | :--- |
| **AppFoundation (Core)** | The logic engine. Contains `APIClient`, `PersistenceProtocol`, `StorageProtocol`, and `SmartRetrier`. | Alamofire, Swinject, Realm |
| **AppFoundationUI** | Resuable UI components and an **Adaptive Design System** with Light/Dark support. | `AppFoundation`, `Kingfisher` |
| **AppFoundationAuth** | Complete Authentication feature (Login/Register flow, Biometrics). | `AppFoundation`, `AppFoundationUI` |

## Core Improvements

### 1. Truly Generic Base
The entire repository has been audited to remove project-specific references (e.g., iBank). It is now a pure foundation suitable for any new project branding or logic.

### 2. Standardized Persistence
We introduced a dual-protocol storage layer:
- **`PersistenceProtocol`**: For raw data (e.g., `DiskStorage`).
- **`StorageProtocol`**: For `Codable` objects (e.g., `JSONStorage`, `SwiftDataStorage`).
- See [Standardized Persistence Guide](../Standardized_Persistence.md) for details.

### 3. Adaptive Design System
The new theme engine uses `UIColor.dynamic` helpers instead of complex Asset Catalog generation.
- **Tokens**: `brandPrimary`, `brandSecondary`, `appBackground`.
- **Theme Awareness**: Sub-components automatically respond to Light/Dark mode changes.
- See [Adaptive Theming Guide](../DesignSystem_Theming.md) for details.

## Smart Networking
Powered by `Alamofire`, our `APIClient` handles:
*   **Automatic Refresh**: Intercepts 401 errors and refreshes sessions.
*   **NWPathMonitor**: Real-time network monitoring to prevent unnecessary retry loops when offline.

## Next Steps
*   [QuickStart Guide](../QuickStart_Guide.md)
*   [Maintenance Guide](../Maintenance_Guide.md)
*   [Module Core](Modules/Core.md)

