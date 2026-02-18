#!/bin/bash
# Script to reorganize AppFoundation repositories into a clean workspace
# Usage: ./reorganize_workspace.sh

# Exit on error
set -e

WORKSPACE_DIR="$HOME/AppFoundation-Workspace"

echo "🚀 Starting workspace reorganization..."

# 1. Create Workspace Directory
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo "Creating workspace at $WORKSPACE_DIR..."
    mkdir -p "$WORKSPACE_DIR"
else
    echo "Workspace directory exists."
fi

# 2. Move AppFoundation (Core)
if [ -d "$HOME/AppFoundation" ] && [ ! -d "$WORKSPACE_DIR/AppFoundation" ]; then
    echo "Moving AppFoundation to workspace..."
    mv "$HOME/AppFoundation" "$WORKSPACE_DIR/"
elif [ -d "$HOME/AppFoundation" ] && [ -d "$WORKSPACE_DIR/AppFoundation" ]; then
    echo "⚠️  Both $HOME/AppFoundation and $WORKSPACE_DIR/AppFoundation exist."
    echo "Assuming workspace version is primary. Root directory will be kept for safety."
else
    echo "AppFoundation already moved or not found in $HOME."
fi

# 3. Clone AppFoundationCLI
if [ ! -d "$WORKSPACE_DIR/AppFoundationCLI" ]; then
    echo "Cloning AppFoundationCLI from $AF_CLI_REMOTE..."
    git clone https://github.com/TomTheCattt/AppFoundationCLI.git "$WORKSPACE_DIR/AppFoundationCLI"
else
    echo "AppFoundationCLI already exists in workspace."
fi

# 4. Configure AppFoundation (Core) Remotes & Cleanup
if [ -d "$WORKSPACE_DIR/AppFoundation" ]; then
    echo "Configuring AppFoundation core remotes..."
    cd "$WORKSPACE_DIR/AppFoundation"
    
    # Ensure origin points to correct repo
    if git remote | grep -q "^origin$"; then
        git remote set-url origin https://github.com/TomTheCattt/AppFoundation.git
    else
        git remote add origin https://github.com/TomTheCattt/AppFoundation.git
    fi
    
    # Remove temporary fix remote
    if git remote | grep -q "^cli-fix$"; then
        git remote remove cli-fix
    fi
    
    # Remove redundant CLI folder
    if [ -d "CLI" ]; then
        echo "Removing redundant CLI folder from AppFoundation core..."
        rm -rf "CLI"
    fi
    cd - > /dev/null
fi

# 5. Configure AppFoundationCLI Remotes
if [ -d "$WORKSPACE_DIR/AppFoundationCLI" ]; then
    echo "Configuring AppFoundationCLI remotes..."
    cd "$WORKSPACE_DIR/AppFoundationCLI"
    
    # Ensure origin points to correct repo
    if git remote | grep -q "^origin$"; then
        git remote set-url origin https://github.com/TomTheCattt/AppFoundationCLI.git
    else
        git remote add origin https://github.com/TomTheCattt/AppFoundationCLI.git
    fi
    cd - > /dev/null
fi

echo ""
echo "✅  Reorganization Logic Applied!"
echo "Current structure:"
echo "$WORKSPACE_DIR/"
echo "├── AppFoundation/       (Remote: https://github.com/TomTheCattt/AppFoundation.git)"
echo "└── AppFoundationCLI/    (Remote: https://github.com/TomTheCattt/AppFoundationCLI.git)"
echo ""
if [ -d "$HOME/AppFoundation" ] && [ -d "$WORKSPACE_DIR/AppFoundation" ]; then
    echo "⚠️  NOTE: You have two copies of AppFoundation."
    echo "Once you verify the one in $WORKSPACE_DIR is correct, you can delete the old one with:"
    echo "rm -rf $HOME/AppFoundation"
fi
echo ""
echo "Please restart your terminal or navigate to $WORKSPACE_DIR to continue working."
