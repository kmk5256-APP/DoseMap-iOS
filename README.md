# DoseMap 🌍

**Chart your course to calculation mastery.**

DoseMap is a stunning, native iOS app that turns NCLEX & NAPLEX dosage calculation practice into an intuitive, map-based adventure. Designed exclusively for nursing and pharmacy students who want the *best* way to master medication math — with a gorgeous, gamified interface that makes learning feel like exploration.

> Only map-based. Purely visual. Deeply effective.

![DoseMap Banner](https://via.placeholder.com/1200x400/0A4D68/FFFFFF?text=DoseMap+%E2%80%94+Master+NCLEX+%26+NAPLEX+Math+on+the+Map)

## Why DoseMap?

Traditional quiz apps are boring lists of problems. DoseMap is different:

- **Map-first experience** — Explore a beautiful custom-illustrated learning map. Every region is a different calculation domain. Travel the trails. Unlock new lands as you master skills.
- **Intuitive & beautiful UI** — Soft medical-teal gradients, elegant typography, spring animations, haptic-ready feedback, and carefully crafted graphics using SwiftUI Canvas + SF Symbols. Feels premium and delightful.
- **Best way to learn the math that actually appears on the exams** — Dimensional analysis focused, step-by-step explanations, unit tracking emphasis (the #1 reason students lose points), realistic clinical scenarios.
- **Gamified progress** — Stars, mastery levels, lit-up paths, streak tracking. Your map *grows* with you.
- **Built for students** — Fast practice sessions, clear explanations, no fluff. Perfect for nursing school, NCLEX prep, NAPLEX calculations, and daily clinical confidence.

## Catchy Name & Positioning

**DoseMap**  
*Navigate. Calculate. Conquer.*

Marketed to nursing students (NCLEX-RN / PN dosage calculations) and pharmacy students (NAPLEX pharmaceutical calculations). Clean, memorable, and instantly communicates the unique map-based approach.

## Features

### The Living Map
- Interactive scrollable / zoomable map with themed regions:
  - **Oral Lands** — Tablets, capsules, oral liquids
  - **IV River** — mL/hr flow rates
  - **Drip Falls** — gtt/min drip rates
  - **Weight Peak** — mg/kg and weight-based dosing
  - **Pediatric Valley** — Safe pediatric calculations
  - **Infusion Highlands** — mcg/kg/min, complex drips
  - **Conversion Crossroads** — Units, ratios, basic conversions
  - **Advanced Outposts** — BSA, dilutions, alligation (NAPLEX flavor)
- Paths light up as you complete regions
- Beautiful node designs with icons, progress rings, and glow effects

### Learning Engine
- 60+ high-quality, exam-style problems with realistic meds and numbers
- Free-text numeric answers + unit selection
- Instant feedback with celebration animations on success
- Full dimensional-analysis style step-by-step solutions
- Review mode for missed questions
- Mastery tracking per region (0–3 stars)

### Design Philosophy
- Dark-mode first with rich teal / deep navy / soft gold accents
- Large, readable type and generous spacing
- Micro-interactions everywhere
- Zero clutter — the map *is* the app

## Tech Stack

- **100% Native iOS** — SwiftUI (iOS 17+)
- No third-party dependencies for the core experience
- Clean MVVM architecture
- Local persistence via `@AppStorage` / UserDefaults for progress
- Ready for future CloudKit / Game Center expansion

## Project Structure

```
DoseMap/
├── DoseMapApp.swift
├── ContentView.swift
├── Models/
│   ├── MapRegion.swift
│   ├── CalculationProblem.swift
│   └── UserProgress.swift
├── ViewModels/
│   ├── MapViewModel.swift
│   └── ProblemViewModel.swift
├── Views/
│   ├── Map/
│   │   ├── LearningMapView.swift
│   │   ├── RegionNodeView.swift
│   │   └── PathConnectorView.swift
│   ├── Problem/
│   │   ├── ProblemView.swift
│   │   ├── AnswerInputView.swift
│   │   └── ExplanationSheet.swift
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   └── Components/
│       ├── ProgressRing.swift
│       ├── CelebrationView.swift
│       └── PrimaryButton.swift
└── Resources/
    └── (SF Symbols + custom gradients used extensively)
```

## How to Run

1. Clone the repo:
   ```bash
   git clone https://github.com/kmk5256-APP/DoseMap-iOS.git
   cd DoseMap-iOS
   ```
2. Open in Xcode 15+ (recommended Xcode 16):
   - Create a new **iOS App** project named `DoseMap` (SwiftUI, Swift).
   - Delete the default ContentView and App files.
   - Drag the entire `DoseMap` source folder into the project (or copy files into the group).
   - Set deployment target to iOS 17.0.
   - Build & Run on simulator or device.

Alternatively, the source is self-contained and ready to drop into any SwiftUI project.

## Roadmap (Future)

- [ ] More problem banks + difficulty tiers
- [ ] Spaced repetition algorithm
- [ ] Custom map themes / night mode variants
- [ ] Apple Pencil support for handwritten practice
- [ ] Share progress / study streaks
- [ ] WatchOS companion for quick drills
- [ ] Full accessibility audit + VoiceOver polish

## Marketing Angle for Students

> "Stop grinding endless multiple-choice lists.  
> Open DoseMap. Pick a region. Solve real exam-style math while your personal learning map lights up.  
> The most beautiful, most effective way to never fear dosage calculations again."

Perfect for Instagram/TikTok nursing student communities, Reddit r/StudentNurse, r/NAPLEX, study groups, and nursing school ambassadors.

## License

MIT — build on it, fork it, make it yours. Attribution appreciated.

---

**Built with care for the next generation of nurses and pharmacists.**  
DoseMap — Navigate. Calculate. Conquer.

Made by Ai2Life Technologies • Pennsylvania
