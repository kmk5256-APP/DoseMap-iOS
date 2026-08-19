import SwiftUI

struct PathConnectorView: View {
    @ObservedObject var progress: UserProgressManager
    
    // Define connections between regions (from -> to)
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
                
                // Gentle curve
                let mid = CGPoint(
                    x: (start.x + end.x) / 2,
                    y: (start.y + end.y) / 2 - 40
                )
                path.addQuadCurve(to: end, control: mid)
                
                let bothUnlocked = progress.isUnlocked(from) && progress.isUnlocked(to)
                let style = StrokeStyle(lineWidth: bothUnlocked ? 3.5 : 2, lineCap: .round, dash: bothUnlocked ? [] : [6, 6])
                
                context.stroke(
                    path,
                    with: .color(bothUnlocked ? Color(red: 0.3, green: 0.75, blue: 0.85).opacity(0.7) : Color.white.opacity(0.15)),
                    style: style
                )
            }
        }
        .allowsHitTesting(false)
    }
}
