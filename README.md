# BaseIOSApp

A comprehensive iOS application template built with Clean Architecture, featuring modern networking with Alamofire, efficient image loading with Kingfisher, and extensive utility extensions.

## 📋 Project Overview

BaseIOSApp is a production-ready iOS application template that demonstrates best practices in iOS development. The project follows Clean Architecture principles with clear separation of concerns across Domain, Data, and Presentation layers.

### Key Features

- ✅ **Clean Architecture** - Modular, testable, and maintainable code structure
- ✅ **Alamofire Integration** - Robust HTTP networking with interceptor support
- ✅ **Kingfisher Integration** - Efficient async image loading and caching
- ✅ **Comprehensive Extensions** - 17+ utility extension files for rapid development
- ✅ **Dependency Injection** - Swinject for IoC container
- ✅ **Local Storage** - Realm for persistence, in-memory database for testing
- ✅ **Code Generation** - SwiftGen for type-safe resources
- ✅ **Code Quality** - SwiftLint for consistent code style

## 🗂️ Project Structure

```
BaseIOSApp/
├── App/                    # Application entry point and configuration
│   ├── Application/        # AppDelegate, SceneDelegate
│   └── DI/                 # Dependency injection setup
├── Core/                   # Core business logic and utilities
│   ├── Network/            # Networking layer (Alamofire-based)
│   ├── Storage/            # Data persistence (Realm, InMemory)
│   ├── Mock/               # Mock server for testing
│   └── Utils/              # Extensions and helpers
├── Features/               # Feature modules (Clean Architecture)
│   ├── Auth/               # Authentication feature
│   ├── Feature/            # Template feature module
│   └── _Template/          # Feature template for new modules
├── UIFoundation/           # Reusable UI components
│   ├── DesignSystem/       # Colors, typography, spacing
│   ├── UIKit/              # UIKit components
│   ├── SwiftUI/            # SwiftUI components
│   └── Extensions/         # UI-related extensions
├── Resources/              # Assets, localizations, generated code
└── Tests/                  # Unit and UI tests
```

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0+
- iOS 15.0+
- CocoaPods (for SwiftGen and SwiftLint)
- Swift Package Manager (for dependencies)

### Installation

1. Clone the repository
2. Run `xcodegen generate` to generate the Xcode project
3. Run `pod install` to install development tools
4. Open `BaseIOSApp.xcworkspace`
5. Build and run (⌘R)

## 📚 Libraries & Dependencies

### Networking - Alamofire

Alamofire provides a robust HTTP networking layer with features like request/response interceptors, automatic retry, and comprehensive error handling.

**Usage Example:**
```swift
// APIClient automatically uses Alamofire
let client = APIClient(interceptors: [AuthInterceptor(), LoggingInterceptor()])
let response = try await client.request(endpoint, responseType: MyModel.self)
```

### Image Loading - Kingfisher

Kingfisher handles async image loading with automatic caching and memory management.

**Usage Example:**
```swift
// Using the UIImageView extension
imageView.setImage(with: imageURL, placeholder: UIImage(systemName: "photo"))

// With custom options
imageView.setImage(
    with: imageURL,
    placeholder: placeholderImage,
    options: [.transition(.fade(0.3)), .cacheOriginalImage]
)
```

## 🛠️ Utility Extensions

The project includes 17+ comprehensive extension files with both basic and advanced helpers:

### UIKit Extensions

- **UIView+Extensions** - Layout, styling, animations (shake, pulse, fade, gradient)
- **UIColor+Extensions** - Hex colors, color manipulation, complementary colors
- **UIViewController+Extensions** - Alerts, child VCs, keyboard handling, loading indicators
- **UITableView+Extensions** - Type-safe cell registration/dequeuing
- **UICollectionView+Extensions** - Type-safe cell registration/dequeuing
- **UIImageView+Extensions** - Kingfisher integration

### Foundation Extensions

- **Array+Extensions** - Safe access, chunking, async map/compactMap
- **Date+Extensions** - Formatting, comparisons, "time ago" strings
- **String+Extensions** - Validation (email), URL conversion, HTML handling
- **Int+Extensions** - Formatting, ordinal, Roman numerals, abbreviation (1K, 1M)
- **Double+Extensions** - Rounding, currency, percentage formatting
- **Dictionary+Extensions** - Safe access, merging, key/value transformations
- **Data+Extensions** - Hex strings, JSON conversion, pretty printing
- **URL+Extensions** - Query parameters, reachability

### Swift Standard Library

- **Optional+Extensions** - Unwrapping helpers, nil checks
- **Collection+Extensions** - Grouping, uniqueness
- **Result+Extensions** - Success/failure checks, error mapping

### Specialized

- **Encodable+Extensions** - JSON dictionary conversion
- **Decodable+Extensions** - Safe decoding
- **Notification+Extensions** - Type-safe notification names

## 🏗️ Architecture

### Clean Architecture Layers

1. **Domain Layer** - Business entities and use cases
2. **Data Layer** - Repositories, DTOs, data sources
3. **Presentation Layer** - ViewModels, Views, Coordinators

### Feature Module Structure

Each feature follows this structure:
```
Feature/
├── Domain/
│   ├── Entities/           # Business models
│   └── UseCases/           # Business logic
├── Data/
│   ├── DTOs/               # Data transfer objects
│   └── Repositories/       # Data access implementations
└── Presentation/
    ├── ViewModel/          # Presentation logic
    └── View/               # UI components
```

## 🧪 Testing

```bash
# Run unit tests
xcodebuild test -workspace BaseIOSApp.xcworkspace -scheme BaseIOSApp -destination 'platform=iOS Simulator,name=iPhone 16'

# Run UI tests
xcodebuild test -workspace BaseIOSApp.xcworkspace -scheme BaseIOSAppUITests -destination 'platform=iOS Simulator,name=iPhone 16'
```

## 🔧 Development Tools

- **SwiftGen** - Generates type-safe code for assets and localizations
- **SwiftLint** - Enforces Swift style and conventions
- **XcodeGen** - Generates Xcode project from YAML configuration

## 📝 Code Style

The project uses SwiftLint to enforce consistent code style. All public/internal functions include comprehensive documentation comments with parameter descriptions and usage examples.

## 🌍 Localization

Localizations are managed in `Resources/Localization/` with support for:
- English (en)
- Vietnamese (vi)

Use SwiftGen-generated strings:
```swift
let text = L10n.welcomeMessage
```

## 🎨 Design System

The design system is centralized in `UIFoundation/DesignSystem/`:
- **Colors** - Semantic color tokens
- **Typography** - Font styles and sizes
- **Spacing** - Consistent spacing values
- **Icons** - SF Symbols catalog

## 📄 License

This project is a template for iOS development. Customize as needed for your projects.

## 🤝 Contributing

This is a template project. Fork and customize for your needs!

---

**Built with ❤️ using Swift, Alamofire, Kingfisher, and modern iOS development practices**
