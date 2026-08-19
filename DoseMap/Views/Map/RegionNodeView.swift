import SwiftUI

struct RegionNodeView: View {
    let region: MapRegion
    let stars: Int
    let isUnlocked: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    @State private var glow = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    // Outer glow ring when unlocked
                    if isUnlocked {
                        Circle()
                            .stroke(region.color.opacity(0.4), lineWidth: 3)
                            .frame(width: 78, height: 78)
                            .scaleEffect(glow ? 1.15 : 1.0)
                            .opacity(glow ? 0.0 : 0.6)
                            .animation(.easeOut(duration: 1.8).repeatForever(autoreverses: false), value: glow)
                    }
                    
                    // Main node
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: isUnlocked ? [
                                    region.color,
                                    region.color.opacity(0.7)
                                ] : [
                                    Color.gray.opacity(0.4),
                                    Color.gray.opacity(0.25)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                        .shadow(color: isUnlocked ? region.color.opacity(0.5) : .clear, radius: 12, y: 4)
                    
                    // Icon
                    Image(systemName: region.icon)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(.white)
                        .opacity(isUnlocked ? 1 : 0.4)
                    
                    // Lock overlay
                    if !isUnlocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white.opacity(0.8))
                            .offset(x: 22, y: -22)
                    }
                }
                
                // Title + stars
                VStack(spacing: 3) {
                    Text(region.title)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(isUnlocked ? .white : .white.opacity(0.4))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    // Stars
                    HStack(spacing: 2) {
                        ForEach(0..<3, id: \.self) { i in
                            Image(systemName: i < stars ? "star.fill" : "star")
                                .font(.system(size: 9))
                                .foregroundStyle(i < stars ? Color.yellow : .white.opacity(0.25))
                        }
                    }
                }
                .frame(width: 90)
            }
            .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(.plain)
        .disabled(!isUnlocked)
        .onAppear {
            if isUnlocked {
                glow = true
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
