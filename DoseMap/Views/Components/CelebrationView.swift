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
        var rotation: Double
    }
    
    private let colors: [Color] = [
        .green, .mint, .cyan, .yellow, .orange,
        Color(red: 0.4, green: 0.85, blue: 0.9),
        Color(red: 0.3, green: 0.7, blue: 1.0)
    ]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { p in
                    Circle()
                        .fill(p.color)
                        .frame(width: 11, height: 11)
                        .scaleEffect(p.scale)
                        .opacity(p.opacity)
                        .rotationEffect(.degrees(p.rotation))
                        .position(x: p.x, y: p.y)
                        .blur(radius: p.scale > 1.2 ? 0.8 : 0)
                }
            }
            .onAppear {
                let centerX = geo.size.width / 2
                let centerY = geo.size.height / 2 - 40
                
                for _ in 0..<32 {
                    let p = Particle(
                        x: centerX + CGFloat.random(in: -30...30),
                        y: centerY,
                        scale: CGFloat.random(in: 0.4...1.6),
                        opacity: 1.0,
                        color: colors.randomElement()!,
                        rotation: Double.random(in: 0...360)
                    )
                    particles.append(p)
                }
                
                withAnimation(.easeOut(duration: 1.35)) {
                    for i in particles.indices {
                        particles[i].x += CGFloat.random(in: -200...200)
                        particles[i].y += CGFloat.random(in: -280...(-50))
                        particles[i].opacity = 0
                        particles[i].scale *= CGFloat.random(in: 0.15...0.4)
                        particles[i].rotation += Double.random(in: -120...120)
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
}
