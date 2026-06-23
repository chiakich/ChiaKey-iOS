# ChiaKey iOS

ChiaKey iOS is the experimental iOS container app and custom keyboard extension for ChiaKey.

This repo is intentionally split from the macOS app repo while the iOS work is still young. For now it consumes the shared engine sources from a sibling checkout:

```text
work/
├── KeyKey-Boneyard/   # ChiaKeyCore, OpenVanilla, OVIMMandarin, bundled DB
└── ChiaKey-iOS/       # iOS app + keyboard extension
```

The current Xcode project points at `../KeyKey-Boneyard/ChiaKey-Source`. Later we can replace that local source dependency with a git submodule, Swift Package, or XCFramework without changing the iOS app folder shape.

## Layout

```text
.
├── App/                 # container app and settings shell
├── KeyboardExtension/   # UIInputViewController and dynamic Zhuyin keyboard shell
├── Shared/              # ObjC++ bridge, paths, and keyboard state
├── Resources/           # iOS-local resources or fixtures
├── Scripts/             # local validation helpers
└── ChiaKey-iOS.xcodeproj
```

## Build Check

```sh
Scripts/test-ios-xcode-build.sh
```

The script builds the `ChiaKey iOS` scheme for iPhone Simulator with code signing disabled and DerivedData under `/private/tmp/ChiaKeyiOSDerived` by default.

## Current Boundaries

- `ChiaKeyCore` and the Smart Mandarin engine still live in `KeyKey-Boneyard`.
- The iOS extension renders composition and candidates inside the keyboard UI, then commits text through `textDocumentProxy`.
- `ChiaKeySource.db` is copied from the main repo's bundled fallback DB during the Xcode build.
- `RequestsOpenAccess` remains `false` until the App Group and Full Access story is intentionally designed.
