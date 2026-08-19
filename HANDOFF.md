# DoseMap — Handoff & Remaining Work

**Repo:** https://github.com/kmk5256-APP/DoseMap-iOS  
**Status as of handoff:** Functional SwiftUI source code complete. Not yet a fully formed Xcode project that opens with one click. Core experience (map + problems + progress + onboarding) is implemented and ready to drop into Xcode.

---

## Current State (What is already done)

- Full SwiftUI source tree under `DoseMap/`
- Map-based UI with 8 regions, unlock system, path connectors, glowing nodes
- ~25 realistic NCLEX/NAPLEX-style calculation problems with step-by-step explanations
- Answer checking with tolerance, celebration particles, feedback banners
- Onboarding flow
- Local progress persistence (stars, solved problems, streak) via UserDefaults
- README with positioning, features, and basic run instructions
- `.gitignore` for Xcode

---

## What is left to do (Prioritized)

### 1. Make it open & build cleanly in Xcode (Required first step)

The repo currently contains **source files only**. There is no `.xcodeproj`.

**Do this:**
1. On a Mac, open Xcode → File → New → Project → iOS App.
2. Product Name: `DoseMap`, Interface: SwiftUI, Language: Swift, Storage: None.
3. Delete the auto-generated `ContentView.swift` and `DoseMapApp.swift`.
4. Drag the entire `DoseMap/` folder from the cloned repo into the Xcode project navigator (create groups, copy items if needed).
5. Set iOS Deployment Target to **17.0** or higher.
6. Build (Cmd+B). Fix any missing-file or type errors that appear.

**Known possible issues to watch for:**
- `ProgressRing.swift` is listed in the README structure but was never created. Either remove the reference or implement a simple circular progress view.
- Star calculation logic in `UserProgress.swift` is simplistic (every ~2 problems = 1 star). Improve if desired.
- Some SF Symbols or animation APIs may need minor version guards depending on exact Xcode version.

### 2. Assets & Visual Polish

- [ ] Create `Assets.xcassets`
  - App Icon (all required sizes) — design a clean map + dose / cross / path motif
  - AccentColor set
  - Optional: launch screen background or custom map textures
- [ ] Improve the map canvas (currently positions + Canvas glows). Consider adding subtle terrain labels, better curved paths, or a background illustration.
- [ ] Add haptics on correct/incorrect answers and region unlocks (`UIImpactFeedbackGenerator`).
- [ ] Test on multiple device sizes (especially iPhone SE and Pro Max).

### 3. Content Expansion

- [ ] Grow the problem bank from ~25 to 60–100+ problems (README currently claims 60+).
- [ ] Add difficulty tiers or “exam mode” (timed, no explanations until end).
- [ ] Add a “Review Missed” mode that pulls only previously wrong problems.
- [ ] More NAPLEX-specific items (alligation, pure dilutions, TPN-style, ratio strength) in Advanced Outposts if you want stronger pharmacy positioning.

### 4. Code Quality & Robustness

- [ ] Replace or harden the star/mastery calculation so it feels fair and predictable.
- [ ] Add basic unit tests for the calculation checking logic (`isCorrect` + tolerance).
- [ ] Consider migrating progress from UserDefaults → SwiftData for future iCloud sync.
- [ ] Add accessibility labels and VoiceOver support on the map nodes and answer fields.
- [ ] Handle empty answer / invalid number input more gracefully.

### 5. Product / Launch Ready

- [ ] Design final App Icon and set of App Store screenshots (map view, problem view, celebration, progress).
- [ ] Write App Store description, keywords, and subtitle.
- [ ] Decide on bundle identifier and create the App in App Store Connect.
- [ ] Privacy policy (even a simple one is required if you collect any data later; currently everything is local).
- [ ] Optional: add a Settings screen (reset progress, about, version).

### 6. Nice-to-haves (Future roadmap already listed in README)

- Spaced repetition
- Custom map themes
- Apple Pencil handwritten practice
- Share streak / progress cards
- watchOS quick drills
- CloudKit progress sync across devices

---

## Quick Start for the Next Person

```bash
git clone https://github.com/kmk5256-APP/DoseMap-iOS.git
cd DoseMap-iOS
# Then follow step 1 above in Xcode
```

Main entry points:
- `DoseMapApp.swift` — app entry
- `ContentView.swift` — root (onboarding vs map)
- `LearningMapView.swift` — the map experience
- `ProblemFlowView` (inside ProblemView.swift) — the practice flow
- `CalculationProblem.swift` — all the content lives here

---

## Ownership / Notes

Built by Ai2Life Technologies (Pennsylvania).  
License: MIT (see README).

When you hand this off, point the next person (or yourself later) at this file first. The biggest remaining gap is turning the source folder into a proper, one-click-openable Xcode project and shipping the assets.
