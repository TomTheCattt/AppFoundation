#!/bin/bash
if which swiftgen >/dev/null 2>&1; then
  swiftgen config run --config "${SRCROOT:-.}/Resources/SwiftGen/swiftgen.yml"
else
  echo "warning: SwiftGen not installed. Run: brew install swiftgen"
fi
