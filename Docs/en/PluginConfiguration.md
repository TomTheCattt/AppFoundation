# Build Tool Plugins Configuration Guide

This guide explains how to configure **SwiftLint** and **SwiftGen** plugins when you add AppFoundation to your project.

## Overview

AppFoundation provides two **SPM Build Tool Plugins**:
1. **SwiftLintPlugin** - Enforces code style during build
2. **SwiftGenPlugin** - Generates type-safe code from assets

These plugins run automatically during your project's build process, but they require:
- The tools installed on your system (`brew install swiftlint swiftgen`)
- Configuration files in **your project** (not in AppFoundation package)

---

## SwiftLint Configuration

### 1. Install SwiftLint

```bash
brew install swiftlint
```

### 2. Create `.swiftlint.yml` in Your Project Root

The SwiftLintPlugin will look for `.swiftlint.yml` in your project's root directory.

**Example `.swiftlint.yml`:**

```yaml
# Disable rules you don't want
disabled_rules:
  - trailing_whitespace
  - line_length

# Enable opt-in rules
opt_in_rules:
  - empty_count
  - closure_spacing

# Exclude files/folders
excluded:
  - Pods
  - .build
  - DerivedData

# Configure specific rules
line_length:
  warning: 120
  error: 200

identifier_name:
  min_length: 2
  max_length: 40
```

### 3. Enable Plugin in Xcode

When you add AppFoundation:
1. Xcode will ask: "Do you want to enable SwiftLintPlugin?"
2. Click **Trust & Enable**

### 4. Verify

Build your project. You should see:
```
Running SwiftLint for YourTarget
```

SwiftLint warnings/errors will appear in Xcode's Issue Navigator.

---

## SwiftGen Configuration

### 1. Install SwiftGen

```bash
brew install swiftgen
```

### 2. Create `swiftgen.yml` in Your Project

SwiftGen needs to know where your assets are and where to output generated code.

**Example `swiftgen.yml`:**

```yaml
# Place this in your project root
input_dir: .
output_dir: Generated

# Generate code for Assets.xcassets
xcassets:
  inputs:
    - YourApp/Assets.xcassets
  outputs:
    - templateName: swift5
      output: Generated/Assets.swift

# Generate code for Localizable.strings
strings:
  inputs:
    - YourApp/Resources/en.lproj
  outputs:
    - templateName: structured-swift5
      output: Generated/Strings.swift

# Generate code for Colors
colors:
  inputs:
    - YourApp/Colors.txt
  outputs:
    - templateName: swift5
      output: Generated/Colors.swift
```

### 3. Adjust Paths for Your Project

Replace `YourApp` with your actual app target name:
- `YourApp/Assets.xcassets` → Your assets catalog path
- `YourApp/Resources/en.lproj` → Your localization files path

### 4. Add Generated Files to Xcode

After SwiftGen runs, add the generated files to your Xcode project:
1. Right-click your project in Navigator
2. Add Files to "YourProject"
3. Select `Generated/Assets.swift`, `Generated/Strings.swift`, etc.

### 5. Enable Plugin

When adding AppFoundation:
1. Xcode asks: "Do you want to enable SwiftGenPlugin?"
2. Click **Trust & Enable**

### 6. Verify

Build your project. You should see:
```
Running SwiftGen for YourTarget
```

Use generated code:
```swift
// Instead of:
UIImage(named: "logo")

// Use type-safe:
Asset.logo.image
```

---

## Plugin Behavior in AppFoundation Package

**Important**: The plugins are configured to work with **your project**, not the AppFoundation package itself.

- **SwiftLintPlugin**: Looks for `.swiftlint.yml` in your project root
- **SwiftGenPlugin**: Looks for `swiftgen.yml` in your project root

If these files don't exist, the plugins will:
- SwiftLint: Use default rules
- SwiftGen: Skip generation (with a warning)

---

## Troubleshooting

### "Command 'swiftlint' not found"

**Solution**: Install SwiftLint
```bash
brew install swiftlint
which swiftlint  # Verify installation
```

### "SwiftGen config not found"

**Solution**: Create `swiftgen.yml` in your project root (see example above)

Or disable the plugin if you don't need it:
- Project Settings → Build Phases → Remove SwiftGenPlugin

### Plugin Not Running

1. Check if plugin is enabled:
   - Project Settings → Build Phases → Run Build Tool Plug-ins
2. Clean build folder: **Cmd+Shift+K**
3. Rebuild: **Cmd+B**

### SwiftLint Rules Too Strict

Edit `.swiftlint.yml` to disable specific rules:
```yaml
disabled_rules:
  - line_length
  - force_cast
```

---

## Disabling Plugins

If you don't want to use the plugins:

1. **Don't enable them** when Xcode prompts
2. Or remove from Build Phases:
   - Project Settings → Build Phases
   - Delete "Run SwiftLintPlugin" and "Run SwiftGenPlugin"

---

## Example Project Structure

```
YourProject/
├── .swiftlint.yml          # SwiftLint config
├── swiftgen.yml            # SwiftGen config
├── YourApp/
│   ├── Assets.xcassets     # Your assets
│   ├── Resources/
│   │   └── en.lproj/       # Localizations
│   └── ...
├── Generated/              # SwiftGen output (gitignored)
│   ├── Assets.swift
│   └── Strings.swift
└── Package Dependencies/
    └── AppFoundation       # This package
```

---

## Next Steps

- See [Installation Guide](Installation.md) for adding AppFoundation
- Read [Core Module Guide](Modules/Core.md) for package features
