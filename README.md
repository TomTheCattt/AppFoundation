# AppFoundation

iOS project scaffolding tool with modular templates and MVVM/Clean Architecture.

## Features

- 🚀 Quick project generation with best practices
- 📦 Modular template system (Core, UI, Features)
- 🏗️ MVVM + Clean Architecture
- 🔄 Remote template fetching and updates
- ✅ Swift 6 compatibility
- 🧪 Built-in testing templates
- 📱 iOS 16.0+ support

## Quick Start

### Install CLI

```bash
curl -fsSL https://raw.githubusercontent.com/TomTheCattt/AppFoundationCLI/main/install.sh | bash
```

### Create New Project

```bash
appfoundation init MyBankingApp
cd MyBankingApp
open MyBankingApp.xcworkspace
```

### Add Features

```bash
appfoundation add feature Auth
appfoundation add feature Profile
```

## Available Modules

### Core Modules
- **core.network** - HTTP networking with Alamofire
- **core.storage** - Data persistence (Realm/SwiftData/JSON)
- **core.di** - Dependency Injection with Swinject
- **core.concurrency** - Swift 6 concurrency utilities

### UI Modules
- **ui.designsystem** - Design tokens and theming
- **ui.components** - Reusable UI components

### Feature Templates
- **auth** - Authentication (Login, Register, Biometric)
- **profile** - User profile management

## Project Structure

```
MyApp/
├── Foundation/          # Core infrastructure
│   ├── Core/           # Network, Storage, DI
│   └── UI/             # Design System, Components
├── Features/           # Business features
│   ├── Auth/
│   └── Profile/
├── App/                # App entry point
└── Tests/              # Unit & UI tests
```

## Architecture

- **MVVM** - Model-View-ViewModel pattern
- **Clean Architecture** - Separation of concerns (Data, Domain, Presentation)
- **Dependency Injection** - Swinject for DI
- **Swift Concurrency** - async/await, actors

## Requirements

- Xcode 15.0+
- iOS 16.0+
- Swift 5.9+
- CocoaPods (optional)
- XcodeGen (optional)

## Documentation

- [Getting Started](Docs/GettingStarted.md)
- [Architecture Guide](Docs/Architecture.md)
- [Module Catalog](MODULES.md)
- [CLI Reference](CLI/README.md)

## Version

Current version: 1.0.0

See [CHANGELOG](CHANGELOG.md) for version history.

## License

MIT License - see LICENSE file for details.

## Contributing

Contributions welcome! Please read CONTRIBUTING.md first.
