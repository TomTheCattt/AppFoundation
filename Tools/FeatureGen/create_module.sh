#!/bin/bash

# Configuration
PROJECT_NAME="AppFoundation"
SOURCES_DIR="Sources"
TESTS_DIR="Tests"

# Check if module name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <ModuleName>"
    echo "Example: $0 UserProfile"
    exit 1
fi

MODULE_NAME=$1
# Capitalize first letter (optional, but good practice)
MODULE_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${MODULE_NAME:0:1})${MODULE_NAME:1}"

FULL_MODULE_NAME="${PROJECT_NAME}${MODULE_NAME}"
TARGET_DIR="${SOURCES_DIR}/${FULL_MODULE_NAME}"
TEST_TARGET_DIR="${TESTS_DIR}/${FULL_MODULE_NAME}Tests"

echo "🚀 creating module: $FULL_MODULE_NAME..."

# Create Sources Directory Structure (Clean Architecture)
mkdir -p "$TARGET_DIR/Domain/Entities"
mkdir -p "$TARGET_DIR/Domain/UseCases"
mkdir -p "$TARGET_DIR/Domain/Repositories"
mkdir -p "$TARGET_DIR/Data/Repositories"
mkdir -p "$TARGET_DIR/Data/DataSources"
mkdir -p "$TARGET_DIR/Data/DTOs"
mkdir -p "$TARGET_DIR/Presentation/View"
mkdir -p "$TARGET_DIR/Presentation/ViewModel"
mkdir -p "$TARGET_DIR/Presentation/Coordinator"
mkdir -p "$TARGET_DIR/DI"

# Create Tests Directory
mkdir -p "$TEST_TARGET_DIR"

# Create Assembly File
cat <<EOF > "$TARGET_DIR/DI/${MODULE_NAME}Assembly.swift"
//
//  ${MODULE_NAME}Assembly.swift
//  $FULL_MODULE_NAME
//
//  Created by FeatureGen.
//

import Swinject
import $PROJECT_NAME

public struct ${MODULE_NAME}Assembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        // Register your dependencies here
        // container.register(${MODULE_NAME}UseCaseProtocol.self) { ... }
    }
}
EOF

# Create Placeholder File to ensure git tracks directories
touch "$TARGET_DIR/Domain/Entities/.keep"

echo "✅ Module structure created at $TARGET_DIR"
echo "✅ Test structure created at $TEST_TARGET_DIR"

echo ""
echo "⚠️  ACTION REQUIRED: Update Package.swift"
echo "Add the following to your 'targets' in Package.swift:"
echo ""
echo ".target("
echo "    name: \"$FULL_MODULE_NAME\","
echo "    dependencies: [\"$PROJECT_NAME\", \"${PROJECT_NAME}UI\"],"
echo "    path: \"$TARGET_DIR\""
echo "),"
echo ".testTarget("
echo "    name: \"${FULL_MODULE_NAME}Tests\","
echo "    dependencies: [\"$FULL_MODULE_NAME\"]"
echo "),"
echo ""
