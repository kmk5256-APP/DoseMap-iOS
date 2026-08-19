import SwiftUI

struct LearningMapView: View {
    @EnvironmentObject var progress: UserProgressManager
    @Binding var selectedRegion: MapRegion?
    @Binding var showProblem: Bool
    
    @State private var scale: CGFloat = 0.85
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    private let mapSize = CGSize(width: 1000, height: 1100)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Atmospheric map background
                mapBackground
                
                // The interactive map canvas
                ZStack {
                    // Path connectors (behind nodes)
                    PathConnectorView(progress: progress)
                    
                    // Region nodes
                    ForEach(RegionType.allCases, id: \.self) { type in
                        let region = MapRegion(type: type)
                        RegionNodeView(
                            region: region,
                            stars: progress.stars(for: type),
                            isUnlocked: progress.isUnlocked(type),
                            onTap: {
                                if progress.isUnlocked(type) {
                                    selectedRegion = region
                                }
                            }
                        )
                        .position(region.position)
                    }
                }
                .frame(width: mapSize.width, height: mapSize.height)
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = min(max(0.6, value), 1.6)
                            },
                        DragGesture()
                            .onChanged { value in
                                offset = CGSize(
                                    width: lastOffset.width + value.translation.width,
                                    height: lastOffset.height + value.translation.height
                                )
                            }
                            .onEnded { _ in
                                lastOffset = offset
                            }
                    )
                )
                
                // Top HUD
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("DoseMap")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            Text("\(progress.totalStars) stars • \(progress.totalProblemsSolved) solved")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        // Streak badge
                        if progress.currentStreak > 0 {
                            HStack(spacing: 6) {
                                Image(systemName: "flame.fill")
                                    .foregroundStyle(.orange)
                                Text("\(progress.currentStreak)")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    
                    Spacer()
                    
                    // Bottom hint
                    Text("Pinch to zoom • Drag to explore • Tap unlocked regions")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.45))
                        .padding(.bottom, 24)
                }
            }
        }
    }
    
    private var mapBackground: some View {
        ZStack {
            // Soft grid / terrain feel
            Canvas { context, size in
                // Subtle radial glows for atmosphere
                for type in RegionType.allCases {
                    let pos = type.position
                    let rect = CGRect(x: pos.x - 80, y: pos.y - 80, width: 160, height: 160)
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(type.accentColor.opacity(0.08))
                    )
                }
            }
            .allowsHitTesting(false)
        }
    }
}
