#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DB="$ROOT_DIR/Resources/ChiaKeySource.db"
SOURCE_DB="${CHIAKEY_SOURCE_DB:-}"

if [[ -z "$SOURCE_DB" ]]; then
  candidates=(
    "$ROOT_DIR/Vendor/ChiaKey/ChiaKey-Source/Distributions/Takao/CookedDatabase/ChiaKeySource.db"
    "$ROOT_DIR/../KeyKey-Boneyard/ChiaKey-Source/Distributions/Takao/CookedDatabase/ChiaKeySource.db"
  )

  for candidate in "${candidates[@]}"; do
    if [[ -f "$candidate" ]]; then
      SOURCE_DB="$candidate"
      break
    fi
  done
fi

if [[ -z "$SOURCE_DB" || ! -f "$SOURCE_DB" ]]; then
  cat >&2 <<'EOF'
ChiaKeySource.db is required before building the keyboard extension.

Provide it with one of these options:
  CHIAKEY_SOURCE_DB=/absolute/path/to/ChiaKeySource.db Scripts/prepare-ios-resources.sh
  place it at Vendor/ChiaKey/ChiaKey-Source/Distributions/Takao/CookedDatabase/ChiaKeySource.db
  keep a sibling KeyKey-Boneyard checkout with the generated database
EOF
  exit 1
fi

mkdir -p "$(dirname "$TARGET_DB")"

if [[ ! -f "$TARGET_DB" ]] || ! cmp -s "$SOURCE_DB" "$TARGET_DB"; then
  cp "$SOURCE_DB" "$TARGET_DB"
fi

echo "Prepared Resources/ChiaKeySource.db from $SOURCE_DB"
