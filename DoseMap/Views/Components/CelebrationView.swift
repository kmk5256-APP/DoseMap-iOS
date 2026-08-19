import SwiftUI

struct CelebrationView: View {
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var scale: CGFloat
        var opacity: Double
        var color: Color
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { p in
                    Circle()
                        .fill(p.color)
                        .frame(width: 10, height: 10)
                        .scaleEffect(p.scale)
                        .opacity(p.opacity)
                        .position(x: p.x, y: p.y)
                }
            }
            .onAppear {
                // Spawn particles
                for _ in 0..<24 {
                    let p = Particle(
                        x: geo.size.width / 2 + CGFloat.random(in: -40...40),
                        y: geo.size.height / 2,
                        scale: CGFloat.random(in: 0.5...1.5),
                        opacity: 1,
                        color: [Color.green, Color.mint, Color.cyan, Color.yellow, Color.orange].randomElement()!
                    )
                    particles.append(p)
                }
                
                // Animate outward
                withAnimation(.easeOut(duration: 1.2)) {
                    for i in particles.indices {
                        particles[i].x += CGFloat.random(in: -180...180)
                        particles[i].y += CGFloat.random(in: -220...(-40))
                        particles[i].opacity = 0
                        particles[i].scale *= 0.3
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
}
