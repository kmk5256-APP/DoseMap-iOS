import SwiftUI

struct ProgressRing: View {
    let progress: Double          // 0.0 ... 1.0
    let color: Color
    var lineWidth: CGFloat = 4
    var size: CGFloat = 72
    
    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            
            // Progress
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(
                    AngularGradient(
                        colors: [color.opacity(0.6), color, color.opacity(0.9)],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.6), value: progress)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ProgressRing(progress: 0.66, color: .cyan)
    }
}
