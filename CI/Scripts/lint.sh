#!/bin/bash
# Run SwiftLint. Use from CI or locally. Requires: brew install swiftlint
set -e
cd "$(dirname "$0")/../.."
if command -v swiftlint >/dev/null 2>&1; then
  swiftlint lint --config Scripts/SwiftLint/.swiftlint.yml --path . 2>&1
else
  echo "SwiftLint not found. Install with: brew install swiftlint"
  exit 1
fi
