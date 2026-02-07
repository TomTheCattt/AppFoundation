# Setup Guide – Phase 1

## Prerequisites

- Xcode 15+
- iOS 15.0+ deployment target

## Steps

1. Open `BaseIOSApp.xcodeproj` in Xcode (create from template if not present).
2. Add Swift Package dependencies:
   - **Swinject:** https://github.com/Swinject/Swinject (2.8.0+)
   - **RealmSwift:** https://github.com/realm/realm-swift (10.40.0+)
3. Add all source folders to the app target: `App/`, `Core/`.
4. Configure build settings to use `Config/Dev.xcconfig` (or Staging/Production) for the scheme.
5. Add Info.plist keys if using xcconfig: `API_BASE_URL`, `ENABLE_LOGGING`, etc., and set in Build Settings from xcconfig.
6. Run tests: Product → Test or `./Scripts/BuildScripts/run_tests.sh`.

## Optional

- Install SwiftGen: `brew install swiftgen` and add Run Script phase for `run_swiftgen.sh`.
- Install SwiftLint: `brew install swiftlint`.
