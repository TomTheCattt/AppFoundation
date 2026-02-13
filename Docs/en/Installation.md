# Installation Guide

AppFoundation is designed as a modular **Swift Package**. You can integrate it into your iOS projects using **Swift Package Manager (SPM)**.

## Prerequisites
- Xcode 15.0+
- iOS 15.0+
- Swift 5.9+

## Option 1: Adding to a New Project (Recommended)

1.  **Open Xcode** and create a new App project or open an existing one.
2.  Go to **File > Add Package Dependencies...**
3.  In the search bar, enter the URL of this repository (or local path if you are developing locally):
    *   `https://github.com/YourOrg/AppFoundation.git`
    *   *Or drag and drop the `AppFoundation` folder into your project.*

4.  **Select Modules**:
    *   **AppFoundation** (Required): Core logic, Networking, Storage.
    *   **AppFoundationUI** (Optional): UI Components, Base ViewControllers.
    *   **AppFoundationAuth** (Optional): Authentication flow.
    *   **AppFoundationResources** (Required): Assets, Themes.

## Option 2: Developing the Package Standalone

If you want to contribute to `AppFoundation` or run the `AppFoundationExample`:

1.  **Open Package.swift**: Double-click `Package.swift` in the root directory. Xcode will open it as a package.
2.  **Select Target**: Choose `AppFoundationExample` scheme.
3.  **Run**: Select a Simulator (e.g., iPhone 16) and press **Cmd+R**.

## Option 3: Generating `.xcodeproj` (Advanced)

If you prefer a traditional `.xcodeproj` file (e.g., for detailed build settings management), we use **XcodeGen**:

1.  **Install XcodeGen**:
    ```bash
    brew install xcodegen
    ```
2.  **Generate Project**:
    Run the following command in the root directory:
    ```bash
    xcodegen generate
    ```
3.  **Open**: Open `AppFoundation.xcodeproj`.

---

## Post-Installation Setup

In your `AppDelegate.swift` or `SceneDelegate.swift`:

```swift
import AppFoundation
import AppFoundationResources

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // 1. Initialize Core Services (Logging, DI)
    AppEnvironment.bootstrap() 
    
    // 2. Setup Theme
    ThemeManager.shared.apply(theme: DefaultTheme())
    
    return true
}
```

---

## Build Tools Setup (Optional but Recommended)

AppFoundation includes **SPM Build Tool Plugins** for **SwiftLint** and **SwiftGen** to ensure code quality and asset generation.

### Installing Build Tools

These tools must be installed on your system for the plugins to work:

```bash
# Install via Homebrew (Recommended)
brew install swiftlint swiftgen

# Or via Mint
mint install realm/SwiftLint
mint install swiftgen/swiftgen
```

> **📖 Detailed Configuration Guide**: See [Plugin Configuration Guide](PluginConfiguration.md) for complete setup instructions including `.swiftlint.yml` and `swiftgen.yml` examples.

### Enabling Plugins in Your Project

When you add AppFoundation to your project, Xcode will ask if you want to enable the build tool plugins:

1. **SwiftLintPlugin**: Runs SwiftLint during build to enforce code style
2. **SwiftGenPlugin**: Generates type-safe asset accessors

**To enable:**
- Click **Trust & Enable** when Xcode prompts you
- Or manually enable via: Project Settings → Build Phases → Run Build Tool Plug-ins

### Verifying Plugin Installation

After enabling, build your project. You should see:
```
Running SwiftLint for YourTarget
Running SwiftGen for YourTarget
```

### Troubleshooting

**"Command 'swiftlint' not found"**
- Ensure SwiftLint is installed: `which swiftlint`
- If not found, install via Homebrew: `brew install swiftlint`

**"SwiftGen config not found"**
- This is normal if you're not using `AppFoundationResources` module
- The plugin will skip generation automatically

**Disabling Plugins**
If you don't want to use the plugins:
- Project Settings → Build Phases → Remove the plugin entries
- Or don't enable them when Xcode prompts

---

## Next Steps

- Read the [Core Module Guide](Modules/Core.md) to understand networking and DI
- Check out [UI Module Guide](Modules/UI.md) for base components
- Explore [Auth Module Guide](Modules/Auth.md) for authentication flows
