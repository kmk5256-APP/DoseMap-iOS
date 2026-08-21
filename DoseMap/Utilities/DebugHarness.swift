#if DEBUG
import SwiftUI

enum DebugHarness {
    static var requestedScreen: String? {
        ProcessInfo.processInfo.arguments
            .first(where: { $0.hasPrefix("--dosemap-screen=") })?
            .split(separator: "=", maxSplits: 1)
            .last
            .map(String.init)
    }
}

struct DebugHarnessView: View {
    let screen: String

    @StateObject private var progress = UserProgressManager()
    @State private var selectedRegion: MapRegion?
    @State private var showProblem = false
    @State private var onboardingPresented = true

    private let oralRegion = MapRegion(type: .oral)

    var body: some View {
        Group {
            switch screen {
            case "onboarding":
                ZStack {
                    Color(red: 0.02, green: 0.12, blue: 0.18).ignoresSafeArea()
                    OnboardingView(isPresented: $onboardingPresented)
                        .environmentObject(progress)
                }
            case "problem":
                ProblemFlowView(region: oralRegion)
                    .environmentObject(progress)
            case "explanation":
                NavigationStack {
                    ExplanationSheet(
                        problem: CalculationProblem.problems(for: .infusion).first!,
                        accent: RegionType.infusion.accentColor
                    )
                }
            case "about":
                AboutView()
            default:
                ZStack {
                    LinearGradient(
                        colors: [
                            Color(red: 0.02, green: 0.12, blue: 0.18),
                            Color(red: 0.04, green: 0.18, blue: 0.28),
                            Color(red: 0.06, green: 0.22, blue: 0.32)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()

                    LearningMapView(
                        selectedRegion: $selectedRegion,
                        showProblem: $showProblem
                    )
                    .environmentObject(progress)
                }
            }
        }
        .onAppear {
            progress.seedForScreenshots()
        }
    }
}
#endif
