# DoseMap — release instructions

DoseMap is a map-based dosage-calculation study app. Read `HANDOFF.md` and
`AppStoreAssets/LISTING.md` before changing release or App Store fields.

## Stack and identity

- SwiftUI, Swift 5, iOS 17+, iPhone only, portrait only.
- No third-party dependencies, account, analytics, ads, or in-app purchases.
- Bundle ID: `com.karankohli.dosemap`; team: `44RB5ZX6TQ`.
- App-specific support and privacy routes are part of the release contract.

## Commands

```bash
xcodebuild -project DoseMap.xcodeproj -scheme DoseMap \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' \
  -derivedDataPath build/DerivedData build

xcodebuild -project DoseMap.xcodeproj -scheme DoseMap \
  -destination 'generic/platform=iOS' -configuration Release \
  -derivedDataPath build/ArchiveData \
  -archivePath build/DoseMap.xcarchive archive

swiftc DoseMap/Models/MapRegion.swift DoseMap/Models/CalculationProblem.swift \
  Tools/validate_content.swift -o build/validate-content && build/validate-content
```

## Hard boundaries

1. DoseMap is education only. It must never present a result as patient-specific
   guidance or claim to verify a real clinical dose.
2. Do not add networking, analytics, advertising, accounts, cloud sync, or a
   purchase gate without an explicit product decision and synchronized privacy work.
3. Problem IDs must remain stable across launches or saved mastery breaks.
4. The generated screenshot harness is `#if DEBUG`; release builds must not expose it.
5. Keep the Ai2Life identity in About/support pages, not a shared permanent top bar.

## Screenshot harness

Launch a Debug build with one of:

`--dosemap-screen=onboarding`, `map`, `problem`, `explanation`, or `about`.

The harness seeds representative local progress and is compiled out of Release.
