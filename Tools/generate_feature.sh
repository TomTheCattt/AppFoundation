#!/bin/bash

# ==============================================================================
#  generate_feature.sh
#  Smart Module Scaffolder
# ==============================================================================

# --- Colors ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# --- Paths ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/../Templates/Feature"
PROJECT_DIR="${2:-$(pwd)}"

# --- Config ---
FEATURE_NAME=$1

if [ -z "$FEATURE_NAME" ]; then
    echo -e "${RED}Error: Please provide a feature name.${NC}"
    echo "Usage: ./generate_feature.sh <FeatureName>"
    exit 1
fi

FEATURE_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${FEATURE_NAME:0:1})${FEATURE_NAME:1}"

# --- Step 1: Framework Detection ---
FRAMEWORK="UIKit" # Default
# Check for SwiftUI App entry point in the main project directory
if grep -r "@main" "$PROJECT_DIR" --exclude-dir="Foundation" --exclude-dir="Features" | grep -q "App"; then
    FRAMEWORK="SwiftUI"
elif grep -r "SwiftUI" "$PROJECT_DIR" --exclude-dir="Foundation" --exclude-dir="Features" | grep -q "View"; then
    FRAMEWORK="SwiftUI"
fi

echo -e "${BLUE}Detected Framework: ${BOLD}$FRAMEWORK${NC}"

# --- Step 2: Folder Creation ---
TARGET_DIR="$PROJECT_DIR/Features/$FEATURE_NAME"
mkdir -p "$TARGET_DIR/Domain/UseCases"
mkdir -p "$TARGET_DIR/Domain/Repositories"
mkdir -p "$TARGET_DIR/Data/Repositories"
mkdir -p "$TARGET_DIR/Presentation"
mkdir -p "$TARGET_DIR/DI"
mkdir -p "$PROJECT_DIR/Features/${FEATURE_NAME}Tests"

# --- Step 3: Template Copying ---
# Assembly
sed "s/{{FEATURE_NAME}}/$FEATURE_NAME/g" "$TEMPLATES_DIR/Assembly.swift.template" > "$TARGET_DIR/DI/${FEATURE_NAME}Assembly.swift"

# ViewModel
sed "s/{{FEATURE_NAME}}/$FEATURE_NAME/g" "$TEMPLATES_DIR/ViewModel.swift.template" > "$TARGET_DIR/Presentation/${FEATURE_NAME}ViewModel.swift"

# View
if [ "$FRAMEWORK" == "SwiftUI" ]; then
    sed "s/{{FEATURE_NAME}}/$FEATURE_NAME/g" "$TEMPLATES_DIR/SwiftUI/View.swift.template" > "$TARGET_DIR/Presentation/${FEATURE_NAME}View.swift"
else
    sed "s/{{FEATURE_NAME}}/$FEATURE_NAME/g" "$TEMPLATES_DIR/UIKit/ViewController.swift.template" > "$TARGET_DIR/Presentation/${FEATURE_NAME}ViewController.swift"
fi

# Tests
sed "s/{{FEATURE_NAME}}/$FEATURE_NAME/g" "$TEMPLATES_DIR/ViewModelTests.swift.template" > "$PROJECT_DIR/Features/${FEATURE_NAME}Tests/${FEATURE_NAME}ViewModelTests.swift"

# Placeholder for Domain/Data
# Placeholder for Domain/Data
cat <<EOF > "$TARGET_DIR/Domain/Repositories/${FEATURE_NAME}RepositoryProtocol.swift"
//
//  ${FEATURE_NAME}RepositoryProtocol.swift
//  ${PROJECT_DIR##*/}
//

import Foundation

public protocol ${FEATURE_NAME}RepositoryProtocol {
    // Protocol definition
}
EOF

cat <<EOF > "$TARGET_DIR/Data/Repositories/${FEATURE_NAME}Repository.swift"
//
//  ${FEATURE_NAME}Repository.swift
//  ${PROJECT_DIR##*/}
//

import Foundation

public class ${FEATURE_NAME}Repository: ${FEATURE_NAME}RepositoryProtocol {
    public init() {}
}
EOF

cat <<EOF > "$TARGET_DIR/Domain/UseCases/${FEATURE_NAME}UseCaseProtocol.swift"
//
//  ${FEATURE_NAME}UseCaseProtocol.swift
//  ${PROJECT_DIR##*/}
//

import Foundation

public protocol ${FEATURE_NAME}UseCaseProtocol {
    // Protocol definition
}
EOF

cat <<EOF > "$TARGET_DIR/Domain/UseCases/${FEATURE_NAME}UseCase.swift"
//
//  ${FEATURE_NAME}UseCase.swift
//  ${PROJECT_DIR##*/}
//

import Foundation

public class ${FEATURE_NAME}UseCase: ${FEATURE_NAME}UseCaseProtocol {
    private let repository: ${FEATURE_NAME}RepositoryProtocol
    
    public init(repository: ${FEATURE_NAME}RepositoryProtocol) {
        self.repository = repository
    }
}
EOF

# Finalize replacements
find "$TARGET_DIR" -type f -name "*.swift" -exec sed -i '' "s/{{PROJECT_NAME}}/$(basename "$PROJECT_DIR")/g" {} +

# --- project.yml Sync ---
if command -v xcodegen >/dev/null 2>&1; then
    if [ -f "$PROJECT_DIR/project.yml" ]; then
        echo -e "${BLUE}Syncing Xcode project via XcodeGen...${NC}"
        xcodegen generate --spec "$PROJECT_DIR/project.yml"
    fi
fi

echo -e "${GREEN}✅ Feature '$FEATURE_NAME' generated successfully at $TARGET_DIR${NC}"
