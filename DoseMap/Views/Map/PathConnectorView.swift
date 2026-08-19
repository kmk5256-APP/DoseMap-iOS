import SwiftUI

struct PathConnectorView: View {
    @ObservedObject var progress: UserProgressManager
    
    private let connections: [(RegionType, RegionType)] = [
        (.oral, .ivFlow),
        (.oral, .weight),
        (.ivFlow, .drip),
        (.weight, .pediatric),
        (.drip, .infusion),
        (.pediatric, .infusion),
        (.conversion, .oral),
        (.conversion, .weight),
        (.infusion, .advanced),
        (.weight, .advanced)
    ]
    
    var body: some View {
        Canvas { context, size in
            for (from, to) in connections {
                let start = from.position
                let end = to.position
                
                var path = Path()
                path.move(to: start)
                
                let mid = CGPoint(
                    x: (start.x + end.x) / 2 + CGFloat.random(in: -8...8),
                    y: (start.y + end.y) / 2 - 48
                )
                path.addQuadCurve(to: end, control: mid)
                
                let unlocked = progress.isUnlocked(from) && progress.isUnlocked(to)
                
                // Glow layer for unlocked paths
                if unlocked {
                    context.stroke(
                        path,
                        with: .color(Color(red: 0.25, green: 0.75, blue: 0.9).opacity(0.25)),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                }
                
                // Main path
                context.stroke(
                    path,
                    with: .color(
                        unlocked
                        ? Color(red: 0.35, green: 0.82, blue: 0.95).opacity(0.85)
                        : Color.white.opacity(0.12)
                    ),
                    style: StrokeStyle(
                        lineWidth: unlocked ? 3.0 : 1.8,
                        lineCap: .round,
                        dash: unlocked ? [] : [5, 7]
                    )
                )
            }
        }
        .allowsHitTesting(false)
    }
}
