#!/bin/bash
# Run unit tests. Use from CI or locally.
set -e
cd "$(dirname "$0")/../.."
SCRIPT_DIR="$(pwd)"
if [ -f "$SCRIPT_DIR/Scripts/BuildScripts/run_tests.sh" ]; then
  bash "$SCRIPT_DIR/Scripts/BuildScripts/run_tests.sh"
else
  xcodebuild test -scheme BaseIOSApp -destination 'platform=iOS Simulator,name=iPhone 16' -quiet 2>&1 || exit 1
fi
