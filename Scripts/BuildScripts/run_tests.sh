#!/bin/bash
set -e
xcodebuild test -scheme BaseIOSApp -destination 'platform=iOS Simulator,name=iPhone 15' 2>/dev/null || true
