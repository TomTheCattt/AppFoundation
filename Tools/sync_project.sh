#!/bin/bash

# --- Colors ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔄 Syncing Project Files to Xcode...${NC}"

PROJECT_DIR="${1:-$(pwd)}"

if [ ! -f "$PROJECT_DIR/project.yml" ]; then
    echo -e "${RED}Error: project.yml not found in $PROJECT_DIR${NC}"
    exit 1
fi

# 1. Run XcodeGen
if command -v xcodegen >/dev/null 2>&1; then
    echo -e "${BLUE}1/2: Regenerating .xcodeproj...${NC}"
    xcodegen generate --spec "$PROJECT_DIR/project.yml"
else
    echo -e "${RED}XcodeGen not found. Please install it via Homebrew: brew install xcodegen${NC}"
    exit 1
fi

# 2. Run Pod Install (Optional)
if [ -f "$PROJECT_DIR/Podfile" ]; then
    if command -v pod >/dev/null 2>&1; then
        echo -e "${BLUE}2/2: Updating CocoaPods...${NC}"
        cd "$PROJECT_DIR"
        pod install
    else
        echo -e "${RED}CocoaPods not found. Please install it or run 'pod install' manually.${NC}"
    fi
fi

echo -e "${GREEN}✅ Synchronization Complete!${NC}"
