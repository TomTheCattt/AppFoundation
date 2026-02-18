# AppFoundation CLI Usage Guide

This guide provides detailed instructions on how to initialize a project and add new components using the `appfoundation` CLI.

## 1. Project Initialization
Run the `init` command to set up a new project or sync an existing one.

```bash
appfoundation init [ProjectName]
```

### Mandatory Components
Every project initialized with AppFoundation includes these core building blocks:
- **Network**: Centralized API client with interceptor support.
- **Logging**: Level-based logger (Debug, Info, Error).
- **Storage Abstractions**: Protocols for persistence that allow swapping Databases (CoreData/Realm/SQLite) without changing business logic.
- **Generated Infrastructure**: Base configuration for SwiftGen and SwiftLint.

---

## 2. Adding Models
To create a new data model with standard templates and unit tests:

```bash
appfoundation add model User
```

**Results**:
- `Foundation/Data/Models/User.swift`: A Codable/Identifiable struct.
- `Tests/FoundationTests/Models/UserTests.swift`: Unit tests for JSON decoding/encoding.

---

## 3. Adding Features
Features follow a Clean Architecture / MVVM approach.

```bash
appfoundation add feature Payment
```

**Results**:
- `Features/Payment/UI/`: View or ViewController.
- `Features/Payment/ViewModel/`: Reactive ViewModel powered by Combine.
- `Features/Payment/Assembly/`: Dependency injection setup.
- `Tests/FeatureTests/PaymentTests/`: ViewModel unit tests with Mocks.

---

## 4. Updating & Re-configuration
If you need to change your Database engine (e.g., from CoreData to Realm) or UI Framework later:

1. Run `appfoundation init`.
2. When asked "Would you like to update project infrastructure?", choose **Y**.
3. Choose **n** when asked to keep existing configuration.
4. Select your new preferences.

> [!TIP]
> Always run `pod install` after changing the database engine to ensure the correct SDKs are linked.
