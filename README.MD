# ChiaKey iOS

ChiaKey iOS is the experimental iOS container app and custom keyboard extension for ChiaKey.

This repo is intentionally split from the macOS app repo while the iOS work is still young. For now it consumes the shared engine sources through a git submodule:

```text
ChiaKey-iOS/
├── Vendor/ChiaKey/   # submodule: ChiaKeyCore, OpenVanilla, OVIMMandarin
├── App/
├── KeyboardExtension/
└── Shared/
```

The current Xcode project points at `Vendor/ChiaKey/ChiaKey-Source` for shared C++ sources. The runtime dictionary is prepared as an iOS-local resource at `Resources/ChiaKeySource.db`, so generated database data stays out of git while the app bundle still gets a concrete file.

## Layout

```text
.
├── App/                 # container app and settings shell
├── KeyboardExtension/   # UIInputViewController and dynamic Zhuyin keyboard shell
├── Resources/           # generated or local iOS resources
├── Scripts/             # local validation and resource preparation helpers
├── Shared/              # ObjC++ bridge, paths, and keyboard state
├── Vendor/ChiaKey/      # shared ChiaKey source submodule
└── ChiaKey-iOS.xcodeproj
```

## Submodule Setup

After cloning this repo, initialize the shared ChiaKey source dependency:

```sh
git submodule update --init --recursive
```

The submodule is pinned by the iOS repo. When updating shared engine code, commit the main ChiaKey repo first, then update `Vendor/ChiaKey` here and commit the new submodule pointer.

## Resource Setup

`Resources/ChiaKeySource.db` is generated locally and ignored by git. The build check prepares it automatically:

```sh
Scripts/prepare-ios-resources.sh
```

The script looks for the database in this order:

1. `CHIAKEY_SOURCE_DB`
2. `Vendor/ChiaKey/ChiaKey-Source/Distributions/Takao/CookedDatabase/ChiaKeySource.db`
3. `../KeyKey-Boneyard/ChiaKey-Source/Distributions/Takao/CookedDatabase/ChiaKeySource.db`

## Build Check

```sh
Scripts/test-ios-xcode-build.sh
```

The script prepares local resources, then builds the `ChiaKey iOS` scheme with code signing disabled and DerivedData under `/private/tmp/ChiaKeyiOSDerived` by default. It uses an iOS Simulator destination when a simulator runtime is installed, otherwise it tries the local Mac `Designed for iPad/iPhone` destination when Xcode exposes one. Override `IOS_DESTINATION` when a specific destination is needed.

## Current Boundaries

- `ChiaKeyCore` and the Smart Mandarin engine live in the `Vendor/ChiaKey` submodule.
- The iOS extension renders composition and candidates inside the keyboard UI, then commits text through `textDocumentProxy`.
- `ChiaKeySource.db` is copied into `Resources/` by `Scripts/prepare-ios-resources.sh` and remains untracked.
- `RequestsOpenAccess` remains `false` until the App Group and Full Access story is intentionally designed.
