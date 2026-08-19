import SwiftUI

struct ContentView: View {
    @EnvironmentObject var progress: UserProgressManager
    @State private var showOnboarding = true
    @State private var selectedRegion: MapRegion? = nil
    @State private var showProblem = false
    
    var body: some View {
        ZStack {
            // Deep atmospheric background
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
            
            if showOnboarding && !progress.hasCompletedOnboarding {
                OnboardingView(isPresented: $showOnboarding)
                    .transition(.opacity.combined(with: .scale))
            } else {
                LearningMapView(
                    selectedRegion: $selectedRegion,
                    showProblem: $showProblem
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showOnboarding)
        .sheet(item: $selectedRegion) { region in
            RegionDetailSheet(region: region, showProblem: $showProblem)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .environmentObject(progress)
        }
        .fullScreenCover(isPresented: $showProblem) {
            if let region = selectedRegion {
                ProblemFlowView(region: region)
                    .environmentObject(progress)
            }
        }
        .onAppear {
            if progress.hasCompletedOnboarding {
                showOnboarding = false
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserProgressManager())
}
