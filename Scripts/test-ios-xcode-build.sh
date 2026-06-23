#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_PATH="$ROOT_DIR/ChiaKey-iOS.xcodeproj"
DERIVED_DATA_PATH="${IOS_DERIVED_DATA_PATH:-/private/tmp/ChiaKeyiOSDerived}"

xcodebuild \
  -quiet \
  -project "$PROJECT_PATH" \
  -scheme "ChiaKey iOS" \
  -configuration Debug \
  -sdk iphonesimulator \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  CODE_SIGNING_ALLOWED=NO \
  build

echo "ChiaKey iOS xcode build: OK"
