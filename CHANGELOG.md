# Changelog

All notable changes to AppFoundation will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-15

### Added
- Initial release of AppFoundation
- Project generation with configurable iOS deployment target
- Dynamic Team ID selection from system keychain
- Platform restrictions (iOS-only, no Mac/Catalyst)
- Persistent project configuration via `.project_factory.conf`
- SwiftGen build phase optimization with input/output files
- Swift 6 compatibility fixes:
  - `@MainActor` isolation for ViewModels
  - `@Sendable` closures for concurrency
  - Actor-based `TaskCoordinator`
  - Thread-safe `AuthInterceptor`
- Feature generation script (`generate_feature.sh`)
- Comprehensive templates for:
  - Network layer (Alamofire)
  - Storage layer (Realm, SwiftData, JSON)
  - Dependency Injection (Swinject)
  - UI components and design system
- CocoaPods integration
- XcodeGen project generation
- SwiftLint configuration
- GitHub Actions CI template

### Fixed
- Bash 3.x compatibility issues on macOS
- Absolute path handling in generation scripts
- Configuration persistence across updates

### Documentation
- Vietnamese documentation in `Docs/vi/`
- Architecture overview
- Module documentation
- Getting started guide

[1.0.0]: https://github.com/yourname/AppFoundation/releases/tag/v1.0.0
