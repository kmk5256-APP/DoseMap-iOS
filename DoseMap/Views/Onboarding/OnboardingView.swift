import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var progress: UserProgressManager
    @State private var page = 0
    
    let pages: [(title: String, subtitle: String, icon: String)] = [
        ("Welcome to DoseMap", "The most beautiful way to master NCLEX & NAPLEX medication math.", "map.fill"),
        ("Explore the Map", "Every region is a calculation domain. Unlock new lands as you earn stars.", "point.topleft.down.to.point.bottomright.curvepath.fill"),
        ("Learn the Right Way", "Dimensional analysis, unit tracking, and clear step-by-step solutions — the skills that actually matter on exam day.", "function"),
        ("Ready to Chart Your Course?", "Start in Oral Lands or Conversion Crossroads. Your journey begins now.", "sailboat.fill")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $page) {
                ForEach(0..<pages.count, id: \.self) { i in
                    VStack(spacing: 32) {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color(red: 0.2, green: 0.6, blue: 0.7).opacity(0.4),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 20,
                                        endRadius: 120
                                    )
                                )
                                .frame(width: 220, height: 220)
                            
                            Image(systemName: pages[i].icon)
                                .font(.system(size: 72, weight: .medium))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.4, green: 0.85, blue: 0.8),
                                            Color(red: 0.3, green: 0.6, blue: 0.95)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .symbolEffect(.pulse, options: .repeating, value: page)
                        }
                        
                        VStack(spacing: 12) {
                            Text(pages[i].title)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                            
                            Text(pages[i].subtitle)
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white.opacity(0.75))
                                .padding(.horizontal, 32)
                        }
                        
                        Spacer()
                        Spacer()
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            // CTA
            Button {
                if page < pages.count - 1 {
                    withAnimation { page += 1 }
                } else {
                    progress.completeOnboarding()
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        isPresented = false
                    }
                }
            } label: {
                Text(page < pages.count - 1 ? "Continue" : "Start Exploring")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.2, green: 0.65, blue: 0.7),
                                Color(red: 0.15, green: 0.45, blue: 0.85)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color(red: 0.2, green: 0.5, blue: 0.7).opacity(0.5), radius: 12, y: 6)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 40)
        }
    }
}
