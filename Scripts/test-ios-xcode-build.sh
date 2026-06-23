#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_PATH="$ROOT_DIR/ChiaKey-iOS.xcodeproj"
DERIVED_DATA_PATH="${IOS_DERIVED_DATA_PATH:-/private/tmp/ChiaKeyiOSDerived}"

resolve_destination() {
  if [[ -n "${IOS_DESTINATION:-}" ]]; then
    printf '%s\n' "$IOS_DESTINATION"
    return
  fi

  if xcrun simctl list runtimes available 2>/dev/null | grep -q '^-- iOS '; then
    printf '%s\n' 'generic/platform=iOS Simulator'
    return
  fi

  local destinations mac_id
  destinations="$(xcodebuild -project "$PROJECT_PATH" -scheme "ChiaKey iOS" -showdestinations 2>/dev/null || true)"
  mac_id="$(awk '/platform:macOS/ { for (i = 1; i <= NF; i++) { if ($i ~ /^id:/) { gsub(/,$/, "", $i); sub(/^id:/, "", $i); print $i; exit } } }' <<<"$destinations")"

  if [[ -n "$mac_id" ]]; then
    printf 'id=%s\n' "$mac_id"
    return
  fi

  printf '%s\n' 'generic/platform=iOS Simulator'
}

DESTINATION="$(resolve_destination)"

"$ROOT_DIR/Scripts/prepare-ios-resources.sh"

echo "Using destination: $DESTINATION"

xcodebuild \
  -quiet \
  -project "$PROJECT_PATH" \
  -scheme "ChiaKey iOS" \
  -configuration Debug \
  -destination "$DESTINATION" \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  CODE_SIGNING_ALLOWED=NO \
  build

echo "ChiaKey iOS xcode build: OK"
