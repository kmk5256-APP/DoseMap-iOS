import SwiftUI

struct RegionNodeView: View {
    let region: MapRegion
    let stars: Int
    let isUnlocked: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    @State private var glowPulse = false
    
    private var masteryProgress: Double {
        Double(stars) / 3.0
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                ZStack {
                    // Soft outer ambient glow
                    if isUnlocked {
                        Circle()
                            .fill(region.color.opacity(0.25))
                            .frame(width: 92, height: 92)
                            .blur(radius: 12)
                            .scaleEffect(glowPulse ? 1.12 : 1.0)
                            .opacity(glowPulse ? 0.5 : 0.8)
                    }
                    
                    // Progress ring (shows mastery)
                    if isUnlocked {
                        ProgressRing(
                            progress: masteryProgress,
                            color: region.color,
                            lineWidth: 3.5,
                            size: 78
                        )
                    } else {
                        Circle()
                            .stroke(Color.white.opacity(0.12), lineWidth: 2)
                            .frame(width: 78, height: 78)
                    }
                    
                    // Main circular node
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: isUnlocked ? [
                                    region.color,
                                    region.color.opacity(0.75)
                                ] : [
                                    Color(white: 0.28),
                                    Color(white: 0.18)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 62, height: 62)
                        .overlay(
                            Circle()
                                .stroke(
                                    isUnlocked ? Color.white.opacity(0.25) : Color.white.opacity(0.08),
                                    lineWidth: 1
                                )
                        )
                        .shadow(
                            color: isUnlocked ? region.color.opacity(0.55) : .clear,
                            radius: 10,
                            y: 4
                        )
                    
                    // Icon
                    Image(systemName: region.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                        .opacity(isUnlocked ? 1.0 : 0.35)
                        .symbolRenderingMode(.hierarchical)
                    
                    // Lock badge
                    if !isUnlocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(5)
                            .background(Circle().fill(Color.black.opacity(0.55)))
                            .offset(x: 24, y: -24)
                    }
                }
                .frame(width: 92, height: 92)
                
                // Title + stars
                VStack(spacing: 4) {
                    Text(region.title)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(isUnlocked ? .white : .white.opacity(0.38))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    
                    HStack(spacing: 3) {
                        ForEach(0..<3, id: \.self) { i in
                            Image(systemName: i < stars ? "star.fill" : "star")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundStyle(i < stars ? Color.yellow : Color.white.opacity(0.22))
                        }
                    }
                }
                .frame(width: 96)
            }
            .scaleEffect(isPressed ? 0.90 : 1.0)
            .animation(.spring(response: 0.28, dampingFraction: 0.65), value: isPressed)
        }
        .buttonStyle(.plain)
        .disabled(!isUnlocked)
        .accessibilityLabel(region.title)
        .accessibilityValue(isUnlocked ? "\(stars) of 3 mastery stars" : "Locked, requires \(region.type.requiredStarsToUnlock) stars")
        .accessibilityHint(isUnlocked ? "Opens practice for this region" : "Complete earlier regions to unlock")
        .onAppear {
            if isUnlocked {
                withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                    glowPulse = true
                }
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
