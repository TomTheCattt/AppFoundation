# AppFoundation Modules

## Core Modules

### Core.Network
**Status**: ✅ Available  
**Dependencies**: None  
**Description**: HTTP networking layer with Alamofire  
**Files**:
- `NetworkManager.swift` - Main network manager
- `RequestInterceptor.swift` - Request/response interceptors
- `ResponseHandler.swift` - Response parsing

**CocoaPods**:
```ruby
pod 'Alamofire', '~> 5.8'
```

---

### Core.Storage
**Status**: ✅ Available  
**Variants**: Realm, SwiftData, JSON  
**Dependencies**: None  
**Description**: Data persistence layer

**Realm Variant**:
```ruby
pod 'RealmSwift', '~> 10.45'
```

---

### Core.DI
**Status**: ✅ Available  
**Dependencies**: None  
**Description**: Dependency Injection with Swinject

**CocoaPods**:
```ruby
pod 'Swinject', '~> 2.8'
```

---

### Core.Concurrency
**Status**: ✅ Available  
**Dependencies**: None  
**Description**: Swift 6 concurrency utilities
**Files**:
- `TaskCoordinator.swift` - Actor-based task management
- `SyncManager.swift` - Network sync coordination

---

## UI Modules

### UI.DesignSystem
**Status**: ✅ Available  
**Dependencies**: None  
**Description**: Design tokens and theming
**Files**:
- `Colors.swift` - Color tokens
- `Typography.swift` - Typography system
- `Spacing.swift` - Spacing scale

---

### UI.Components
**Status**: 🚧 Planned  
**Dependencies**: `ui.designsystem`  
**Description**: Reusable UI components

---

## Feature Templates

### Feature.Auth
**Status**: 🚧 Planned  
**Architecture**: MVVM + Clean Architecture  
**Dependencies**: `core.network`, `core.storage`, `core.di`  
**Description**: Authentication (Login, Register, Biometric)

---

### Feature.Profile
**Status**: 🚧 Planned  
**Architecture**: MVVM + Clean Architecture  
**Dependencies**: `core.network`, `core.storage`, `core.di`  
**Description**: User profile management

---

## Testing Modules

### Testing.Unit
**Status**: 🚧 Planned  
**Description**: Unit test templates and helpers

---

### Testing.UI
**Status**: 🚧 Planned  
**Description**: UI test templates

---

## Legend
- ✅ Available - Ready to use
- 🚧 Planned - Coming soon
- ⚠️ Deprecated - Use alternative

## Version Compatibility

| Module | Min iOS | Swift | Xcode |
|--------|---------|-------|-------|
| Core.Network | 16.0 | 5.9 | 15.0 |
| Core.Storage.Realm | 16.0 | 5.9 | 15.0 |
| Core.DI | 16.0 | 5.9 | 15.0 |
| UI.DesignSystem | 16.0 | 5.9 | 15.0 |
