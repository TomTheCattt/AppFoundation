#!/bin/bash

# ==============================================================================
#  generate_foundation.sh
#  Project Factory Orchestrator
#  Author: Project Factory Team
# ==============================================================================

# --- Colors ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# --- Paths ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/../Templates"
LOG_FILE="scaffold_report.log"

# --- Header ---
clear
echo -e "${BLUE}${BOLD}"
echo "===================================================="
echo "      🚀 WELCOME TO PROJECT FACTORY iOS v1.0         "
echo "===================================================="
echo -e "${NC}"

# --- Logging setup ---
echo "Starting Scaffolding at $(date)" > "$LOG_FILE"

log_info() { echo -e "${BLUE}INFO:${NC} $1"; echo "INFO: $1" >> "$LOG_FILE"; }
log_success() { echo -e "${GREEN}SUCCESS:${NC} $1"; echo "SUCCESS: $1" >> "$LOG_FILE"; }
log_warn() { echo -e "${YELLOW}WARNING:${NC} $1"; echo "WARNING: $1" >> "$LOG_FILE"; }
log_error() { echo -e "${RED}ERROR:${NC} $1"; echo "ERROR: $1" >> "$LOG_FILE"; exit 1; }

# --- Persistence Support ---
CONFIG_FILE=".project_factory.conf"

load_config() {
    local search_path="$1"
    if [[ -f "$search_path/$CONFIG_FILE" ]]; then
        source "$search_path/$CONFIG_FILE"
        log_info "Existing configuration loaded from $search_path/$CONFIG_FILE"
        CONFIG_LOADED=true
    else
        CONFIG_LOADED=false
    fi
}

save_config() {
    cat <<EOF > "$PROJECT_ROOT/$CONFIG_FILE"
# AppFoundation Project Configuration
PROJECT_MODE="$PROJECT_MODE"
FRAMEWORK_CHOICE="$FRAMEWORK_CHOICE"
STORAGE_INTENT="$STORAGE_INTENT"
DB_CHOICE="${DB_CHOICE:-"3"}"
INCLUDE_DEBUG="$INCLUDE_DEBUG"
INCLUDE_CI="$INCLUDE_CI"
INCLUDE_AUTH="$INCLUDE_AUTH"
APP_NAME="$APP_NAME"
BUNDLE_ID="$BUNDLE_ID"
IOS_DEPLOYMENT_TARGET="$IOS_DEPLOYMENT_TARGET"
TEAM_ID="$TEAM_ID"
PROFILE_NAME="$PROFILE_NAME"
EOF
    log_info "Configuration saved to $PROJECT_ROOT/$CONFIG_FILE"
}

# --- Step 1: Mode Selection ---
log_info "Step 1: Project Mode Selection"
echo -e "\n${BOLD}How would you like to start?${NC}"
echo "1) New Project (Create from scratch)"
echo "2) Integration Mode (Add foundation to existing project)"
read -p "Select [1-2]: " PROJECT_MODE

if [[ $PROJECT_MODE == "2" ]]; then
    read -p "Enter path to existing project root [default: ./]: " TARGET_PATH
    TARGET_PATH=${TARGET_PATH:-"."}
    load_config "$TARGET_PATH"
else
    # New Project mode will create a folder with APP_NAME
    TARGET_PATH=""
fi

# --- Step 2: Framework Selection ---
log_info "Step 2: Framework Selection"
echo -e "\n${BOLD}Which UI Framework would you like to use?${NC}"
echo "1) UIKit (Coordinator Pattern + SnapKit)"
echo "2) SwiftUI (ViewStyles + Clean Architecture)"
echo "3) Hybrid (Both with interoperability templates)"
read -p "Select [1-3] [default: ${FRAMEWORK_CHOICE:-1}]: " NEW_FRAMEWORK_CHOICE
FRAMEWORK_CHOICE=${NEW_FRAMEWORK_CHOICE:-${FRAMEWORK_CHOICE:-"1"}}

# --- Step 3: Storage Wizard ---
log_info "Step 3: Storage Wizard"
echo -e "\n${BOLD}What is the primary purpose of your app's data?${NC}"
echo -e "${YELLOW}A) Online Only${NC}: Data lives on server, interacts via API only."
echo "   - Pros: Simple app, no local database overhead."
echo "   - Cons: No offline support."
echo -e "${YELLOW}B) Offline Only${NC}: App works entirely on device (Note, Diary)."
echo "   - Pros: Super fast, privacy first, no internet needed."
echo "   - Cons: No sync, no backup."
echo -e "${YELLOW}C) Hybrid (Online + Offline Support)${NC}: The Professional choice."
echo "   - Pros: Data is cached locally, works offline, syncs when possible."
echo "   - Cons: Complex architecture (Repository Pattern)."
read -p "Select [A/B/C] [default: ${STORAGE_INTENT:-A}]: " NEW_STORAGE_INTENT
STORAGE_INTENT=$(echo "${NEW_STORAGE_INTENT:-${STORAGE_INTENT:-"A"}}" | tr '[:lower:]' '[:upper:]')

# --- Step 4: Database Selection ---
echo -e "\n${BOLD}Which database engine would you prefer?${NC}"
case $STORAGE_INTENT in
    B|C)
        echo "1) Realm (High performance, complex relationships)"
        echo "2) SwiftData/CoreData (Native Apple, iCloud sync)"
        echo "3) JSON (Lightweight file-base, no dependency)"
        read -p "Select [1-3] [default: ${DB_CHOICE:-3}]: " NEW_DB_CHOICE
        DB_CHOICE=${NEW_DB_CHOICE:-${DB_CHOICE:-"3"}}
        ;;
    *)
        log_info "Skipping DB selection for Online-only mode."
        ;;
esac

# --- Step 5: Advanced Features ---
log_info "Step 5: Advanced Features"
echo -e "\n${BOLD}Would you like to include Enterprise Features?${NC}"
read -p "Include In-App Debug Menu? (y/n) [default: ${INCLUDE_DEBUG:-n}]: " NEW_INCLUDE_DEBUG
INCLUDE_DEBUG=${NEW_INCLUDE_DEBUG:-${INCLUDE_DEBUG:-"n"}}
read -p "Include GitHub Actions CI? (y/n) [default: ${INCLUDE_CI:-n}]: " NEW_INCLUDE_CI
INCLUDE_CI=${NEW_INCLUDE_CI:-${INCLUDE_CI:-"n"}}
read -p "Include Biometric Authentication logic? (y/n) [default: ${INCLUDE_AUTH:-n}]: " NEW_INCLUDE_AUTH
INCLUDE_AUTH=${NEW_INCLUDE_AUTH:-${INCLUDE_AUTH:-"n"}}

# --- Step 6: Metadata ---
echo -e "\n${BOLD}Project Metadata${NC}"
read -p "Enter Project Name (e.g. MySuperApp) [default: ${APP_NAME:-MySuperApp}]: " NEW_APP_NAME
APP_NAME=${NEW_APP_NAME:-${APP_NAME:-"MySuperApp"}}

# Use tr for lowercase conversion (Bash 3.x compatibility)
LOW_APP_NAME=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')
DEFAULT_BUNDLE_ID="com.example.$LOW_APP_NAME"

read -p "Enter Bundle Identifier (e.g. com.example.app) [default: ${BUNDLE_ID:-$DEFAULT_BUNDLE_ID}]: " NEW_BUNDLE_ID
BUNDLE_ID=${NEW_BUNDLE_ID:-${BUNDLE_ID:-$DEFAULT_BUNDLE_ID}}

# --- Step 7: Deployment Target ---
log_info "Step 7: iOS Deployment Target"
while true; do
    read -p "Enter iOS Target Deployment (minimum 16.0) [default: ${IOS_DEPLOYMENT_TARGET:-16.0}]: " NEW_IOS_DEPLOYMENT_TARGET
    NEW_VAL=${NEW_IOS_DEPLOYMENT_TARGET:-${IOS_DEPLOYMENT_TARGET:-"16.0"}}
    
    # Simple integer check for minimum version
    MAJOR_VERSION=$(echo "$NEW_VAL" | cut -d'.' -f1)
    if [[ "$MAJOR_VERSION" -ge 16 ]]; then
        IOS_DEPLOYMENT_TARGET="$NEW_VAL"
        break
    else
        log_warn "Minimum iOS version is 16.0 (Major version $MAJOR_VERSION detected). Please try again."
    fi
done

# --- Step 8: Code Signing ---
log_info "Step 8: Code Signing Configuration"
echo -e "\n${BOLD}Searching for available Development Team IDs...${NC}"
TEAMS=($(security find-identity -p codesigning -v | grep -oE "\([A-Z0-9]{10}\)" | tr -d "()" | sort -u))

if [ ${#TEAMS[@]} -eq 0 ]; then
    log_warn "No signing identities found. Please enter Team ID manually."
    read -p "Enter Development Team ID: " TEAM_ID
else
    echo "Available Team IDs:"
    for i in "${!TEAMS[@]}"; do
        IDENTITY_NAME=$(security find-identity -p codesigning -v | grep "${TEAMS[$i]}" | head -1 | sed -E 's/.*"([^"]+)".*/\1/')
        echo "$((i+1))) ${TEAMS[$i]} ($IDENTITY_NAME)"
    done
    echo "$(( ${#TEAMS[@]} + 1 ))) Enter manually"
    
    while true; do
        read -p "Select Team ID [1-$(( ${#TEAMS[@]} + 1 ))]: " TEAM_CHOICE
        if [[ "$TEAM_CHOICE" -eq "$(( ${#TEAMS[@]} + 1 ))" ]]; then
            read -p "Enter Development Team ID: " TEAM_ID
            break
        elif [[ "$TEAM_CHOICE" -ge 1 && "$TEAM_CHOICE" -le "${#TEAMS[@]}" ]]; then
            TEAM_ID=${TEAMS[$((TEAM_CHOICE-1))]}
            break
        else
            log_warn "Invalid selection. Please try again."
        fi
    done
fi

read -p "Enter Provisioning Profile Name (Optional) [default: ${PROFILE_NAME:-None}]: " NEW_PROFILE_NAME
PROFILE_NAME=${NEW_PROFILE_NAME:-${PROFILE_NAME:-""}}
if [[ $PROFILE_NAME == "None" ]]; then PROFILE_NAME=""; fi

# --- Summary & Confirmation ---
echo -e "\n${GREEN}${BOLD}CONFIRMATION SUMMARY:${NC}"
echo "------------------------------------"
echo "Project Name:      $APP_NAME"
echo "Framework:         $( [ "$FRAMEWORK_CHOICE" == "1" ] && echo "UIKit" || [ "$FRAMEWORK_CHOICE" == "2" ] && echo "SwiftUI" || echo "Hybrid" )"
echo "Storage:           $STORAGE_INTENT"
echo "Bundle ID:         $BUNDLE_ID"
echo "Deployment Target: iOS $IOS_DEPLOYMENT_TARGET"
echo "Development Team:  $TEAM_ID"
echo "Provisioning:      ${PROFILE_NAME:-"Automatic"}"
echo "------------------------------------"
read -p "Proceed with generation? (y/n): " CONFIRM
if [[ $CONFIRM != "y" ]]; then
    log_warn "Scaffolding cancelled by user."
    exit 0
fi

# ==============================================================================
#  EXECUTION START
# ==============================================================================

if [[ $PROJECT_MODE == "2" ]]; then
    PROJECT_ROOT=$(cd "$TARGET_PATH" && pwd)
else
    # New Project mode will create a folder with APP_NAME
    # Using absolute path for robustness
    PROJECT_ROOT="$(pwd)/$APP_NAME"
fi

log_info "Creating foundation structure in: $PROJECT_ROOT..."
mkdir -p "$PROJECT_ROOT/Foundation/Core"
mkdir -p "$PROJECT_ROOT/Foundation/UI"
mkdir -p "$PROJECT_ROOT/Foundation/Extensions"
mkdir -p "$PROJECT_ROOT/Tools"
mkdir -p "$PROJECT_ROOT/App"

# --- Copy Templates ---
log_info "Injecting Core Foundation templates..."
cp -r "$TEMPLATES_DIR/Foundation/Core/"* "$PROJECT_ROOT/Foundation/Core/"
cp -r "$TEMPLATES_DIR/Foundation/Extensions/"* "$PROJECT_ROOT/Foundation/Extensions/"
cp -r "$TEMPLATES_DIR/Foundation/UI/"* "$PROJECT_ROOT/Foundation/UI/"

# --- Conditional Feature Injection ---
if [[ $DB_CHOICE != "3" ]]; then
    log_info "Removing JSONStorage (Not selected)..."
    rm "$PROJECT_ROOT/Foundation/Core/JSONStorage.swift"
fi

if [[ $DB_CHOICE != "1" ]]; then
    log_info "Removing RealmStorage (Not selected)..."
    rm "$PROJECT_ROOT/Foundation/Core/RealmStorage.swift"
fi

if [[ $DB_CHOICE != "2" ]]; then
    log_info "Removing SwiftDataStorage (Not selected)..."
    rm "$PROJECT_ROOT/Foundation/Core/SwiftDataStorage.swift"
fi

if [[ $INCLUDE_DEBUG != "y" ]]; then
    log_info "Removing DebugMenu & AppLogReporter (Not selected)..."
    rm "$PROJECT_ROOT/Foundation/UI/DebugMenu.swift"
    rm "$PROJECT_ROOT/Foundation/Core/AppLogReporter.swift"
fi

if [[ $INCLUDE_AUTH != "y" ]]; then
    log_info "Removing BiometricManager (Not selected)..."
    rm "$PROJECT_ROOT/Foundation/Core/BiometricManager.swift"
fi

if [[ $INCLUDE_CI == "y" ]]; then
    log_info "Setting up GitHub Actions..."
    mkdir -p "$PROJECT_ROOT/.github/workflows"
    sed "s/{{PROJECT_NAME}}/$APP_NAME/g" "$TEMPLATES_DIR/Foundation/CI/github_action.yml.template" > "$PROJECT_ROOT/.github/workflows/ci.yml"
fi

# --- Static Analysis & Code Gen Setup ---
log_info "Setting up SwiftGen & SwiftLint configs..."
cp "$TEMPLATES_DIR/Foundation/Core/swiftgen.yml.template" "$PROJECT_ROOT/swiftgen.yml"
cp "$TEMPLATES_DIR/Foundation/Core/swiftlint.yml.template" "$PROJECT_ROOT/.swiftlint.yml"

# Create SwiftGen directory structure
mkdir -p "$PROJECT_ROOT/Foundation/Resources/Localization/en.lproj"
mkdir -p "$PROJECT_ROOT/Foundation/Resources/Assets.xcassets"
mkdir -p "$PROJECT_ROOT/Foundation/Generated"
echo '"app_name" = "{{PROJECT_NAME}}";' > "$PROJECT_ROOT/Foundation/Resources/Localization/en.lproj/Localizable.strings"

# Create color assets for SwiftGen
cat > "$PROJECT_ROOT/Foundation/Resources/Assets.xcassets/Contents.json" << 'EOF'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Create Colors folder
mkdir -p "$PROJECT_ROOT/Foundation/Resources/Assets.xcassets/Colors.colorset"
cat > "$PROJECT_ROOT/Foundation/Resources/Assets.xcassets/Colors.colorset/Contents.json" << 'EOF'
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "1.000",
          "green" : "0.478",
          "red" : "0.000"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Create primary color
mkdir -p "$PROJECT_ROOT/Foundation/Resources/Assets.xcassets/primary.colorset"
cat > "$PROJECT_ROOT/Foundation/Resources/Assets.xcassets/primary.colorset/Contents.json" << 'EOF'
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "1.000",
          "green" : "0.478",
          "red" : "0.000"
        }
      },
      "idiom" : "universal"
    },
    {
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ],
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "1.000",
          "green" : "0.600",
          "red" : "0.200"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Create secondary color
mkdir -p "$PROJECT_ROOT/Foundation/Resources/Assets.xcassets/secondary.colorset"
cat > "$PROJECT_ROOT/Foundation/Resources/Assets.xcassets/secondary.colorset/Contents.json" << 'EOF'
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0.322",
          "green" : "0.176",
          "red" : "0.345"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Create background color
mkdir -p "$PROJECT_ROOT/Foundation/Resources/Assets.xcassets/background.colorset"
cat > "$PROJECT_ROOT/Foundation/Resources/Assets.xcassets/background.colorset/Contents.json" << 'EOF'
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "1.000",
          "green" : "1.000",
          "red" : "1.000"
        }
      },
      "idiom" : "universal"
    },
    {
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ],
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0.000",
          "green" : "0.000",
          "red" : "0.000"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# --- Advanced project.yml Injection ---
log_info "Injecting advanced project.yml..."
BUNDLE_PREFIX=$(echo "$BUNDLE_ID" | rev | cut -d'.' -f2- | rev)
sed -e "s/{{PROJECT_NAME}}/$APP_NAME/g" \
    -e "s/{{BUNDLE_ID}}/$BUNDLE_ID/g" \
    -e "s/{{BUNDLE_ID_PREFIX}}/$BUNDLE_PREFIX/g" \
    -e "s/{{DEPLOYMENT_TARGET}}/$IOS_DEPLOYMENT_TARGET/g" \
    -e "s/{{DEVELOPMENT_TEAM}}/$TEAM_ID/g" \
    -e "s/{{PROVISIONING_PROFILE}}/$PROFILE_NAME/g" \
    "$TEMPLATES_DIR/Foundation/Core/project.yml.template" > "$PROJECT_ROOT/project.yml"

# --- Copy App Templates ---
log_info "Setting up App structure..."
sed "s/{{PROJECT_NAME}}/$APP_NAME/g" "$TEMPLATES_DIR/Foundation/App/App.swift.template" > "$PROJECT_ROOT/App/App.swift"
sed "s/{{PROJECT_NAME}}/$APP_NAME/g" "$TEMPLATES_DIR/Foundation/App/entitlements.template" > "$PROJECT_ROOT/App/$APP_NAME.entitlements"

# --- Replacement Logic ---
log_info "Personalizing templates with '$APP_NAME'..."
find "$PROJECT_ROOT/Foundation" -type f -name "*.swift" -exec sed -i '' "s/{{PROJECT_NAME}}/$APP_NAME/g" {} +

# --- Feature Template Injection ---
log_info "Generating initial 'Core' module..."
# Ensure Features directory exists
mkdir -p "$PROJECT_ROOT/Features"
mkdir -p "$PROJECT_ROOT/Tests/UnitTests"
mkdir -p "$PROJECT_ROOT/Tests/UITests"

# Execute feature generation using absolute path to script
"$SCRIPT_DIR/generate_feature.sh" Core "$PROJECT_ROOT"

# --- Dependency Management ---
log_info "Detecting CocoaPods..."
if command -v pod >/dev/null 2>&1; then
    cd "$PROJECT_ROOT"
    log_info "Generating Podfile..."
    
    # Start Podfile
    cat <<EOF > Podfile
platform :ios, '$IOS_DEPLOYMENT_TARGET'
use_frameworks!

# Global build tools
pod 'SwiftLint'
pod 'SwiftGen'

target 'AppFoundationUI' do
  pod 'Alamofire'
  pod 'Swinject'
  pod 'Kingfisher'
EOF

    # Add optional pods to AppFoundationUI
    if [ "$DB_CHOICE" == "1" ]; then
        echo "  pod 'RealmSwift'" >> Podfile
    fi
    
    if [ "$FRAMEWORK_CHOICE" == "1" ] || [ "$FRAMEWORK_CHOICE" == "3" ]; then
        echo "  pod 'SnapKit'" >> Podfile
        echo "  pod 'IQKeyboardManagerSwift'" >> Podfile
    fi

    cat <<EOF >> Podfile
end

target 'AppFeatures' do
  # Inherits from AppFoundationUI via dependency
  pod 'Swinject'
end

target '${APP_NAME}' do
  # Main App Target
  pod 'Alamofire'
  pod 'Kingfisher'
  pod 'Swinject'
EOF

    if [ "$DB_CHOICE" == "1" ]; then
        echo "  pod 'RealmSwift'" >> Podfile
    fi

    if [ "$FRAMEWORK_CHOICE" == "1" ] || [ "$FRAMEWORK_CHOICE" == "3" ]; then
        echo "  pod 'SnapKit'" >> Podfile
        echo "  pod 'IQKeyboardManagerSwift'" >> Podfile
    fi

    cat <<EOF >> Podfile
end

target 'AppFeaturesTests' do
  inherit! :search_paths
end
EOF

    # Sync Project BEFORE Pod Install to ensure targets exist
    if command -v xcodegen >/dev/null 2>&1; then
        if [ -f "project.yml" ]; then
            log_info "Syncing Xcode project via XcodeGen..."
            xcodegen generate --spec "project.yml"
        fi
    fi

    log_info "Running pod install (this may take a minute)..."
    pod install >> "$LOG_FILE" 2>&1
    cd - > /dev/null
else
    log_warn "CocoaPods not found. Please run 'pod install' manually in $PROJECT_ROOT."
fi

# Remove redundant xcodegen block at the end since we moved it up

# --- project.yml Sync ---

# --- Save Configuration ---
save_config

log_success "Foundation Generation Completed for $APP_NAME! Check $LOG_FILE for details."
echo -e "\n${BOLD}Next Step: Open $APP_NAME.xcworkspace and start coding!${NC}"
