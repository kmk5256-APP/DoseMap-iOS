import SwiftUI

struct LearningMapView: View {
    @EnvironmentObject var progress: UserProgressManager
    @Binding var selectedRegion: MapRegion?
    @Binding var showProblem: Bool
    
    @State private var scale: CGFloat = 0.82
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    private let mapSize = CGSize(width: 1000, height: 1100)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Rich atmospheric background
                mapBackground
                
                // Interactive map
                ZStack {
                    PathConnectorView(progress: progress)
                    
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
                                let newScale = 0.82 * value
                                scale = min(max(0.55, newScale), 1.55)
                            }
                            .onEnded { _ in
                                // keep current scale
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
                
                // Top HUD with material
                VStack(spacing: 0) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("DoseMap")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Text("\(progress.totalStars) stars  ·  \(progress.totalProblemsSolved) solved")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.65))
                        }
                        
                        Spacer()
                        
                        if progress.currentStreak > 0 {
                            HStack(spacing: 5) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(
                                        LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom)
                                    )
                                Text("\(progress.currentStreak)")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.orange.opacity(0.35), lineWidth: 1)
                                    )
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 10)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.45),
                                Color.black.opacity(0.0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    Spacer()
                    
                    // Bottom instruction pill
                    Text("Pinch to zoom  ·  Drag to explore  ·  Tap regions")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial.opacity(0.7))
                        )
                        .padding(.bottom, 28)
                }
            }
        }
    }
    
    private var mapBackground: some View {
        ZStack {
            // Deep base gradient already provided by ContentView, but reinforce atmosphere
            Canvas { context, size in
                // Soft colored glows under each region
                for type in RegionType.allCases {
                    let pos = type.position
                    let radius: CGFloat = type == .advanced || type == .infusion ? 110 : 90
                    let rect = CGRect(
                        x: pos.x - radius,
                        y: pos.y - radius,
                        width: radius * 2,
                        height: radius * 2
                    )
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(type.accentColor.opacity(0.09))
                    )
                }
                
                // Very subtle center vignette feel via extra soft circles
                let centerGlow = CGRect(x: 350, y: 400, width: 300, height: 300)
                context.fill(
                    Path(ellipseIn: centerGlow),
                    with: .color(Color(red: 0.15, green: 0.35, blue: 0.45).opacity(0.06))
                )
            }
            .allowsHitTesting(false)
            
            // Soft radial vignette overlay
            RadialGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.35)
                ],
                center: .center,
                startRadius: 180,
                endRadius: 520
            )
            .allowsHitTesting(false)
            .blendMode(.multiply)
        }
    }
}
