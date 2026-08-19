import SwiftUI

struct RegionDetailSheet: View {
    let region: MapRegion
    @Binding var showProblem: Bool
    @EnvironmentObject var progress: UserProgressManager
    @Environment(\.dismiss) var dismiss
    
    private var stars: Int {
        progress.stars(for: region.type)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 28) {
                // Header
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [region.color.opacity(0.35), region.color.opacity(0.12)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 68, height: 68)
                        
                        Image(systemName: region.icon)
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(region.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(region.title)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                        
                        HStack(spacing: 5) {
                            ForEach(0..<3, id: \.self) { i in
                                Image(systemName: i < stars ? "star.fill" : "star")
                                    .font(.system(size: 13))
                                    .foregroundStyle(i < stars ? .yellow : .secondary.opacity(0.5))
                            }
                            Text("\(stars)/3 mastery")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                
                // Description
                Text(region.description)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(3)
                
                // Problem count pill
                let problems = CalculationProblem.problems(for: region.type)
                HStack(spacing: 8) {
                    Image(systemName: "list.bullet.rectangle")
                        .font(.system(size: 14))
                    Text("\(problems.count) practice problems")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                }
                .foregroundStyle(region.color)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(region.color.opacity(0.12))
                )
                
                Spacer()
                
                PrimaryButton(title: "Start Practicing", accent: region.color) {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        showProblem = true
                    }
                }
            }
            .padding(24)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                        .fontWeight(.medium)
                }
            }
        }
    }
}
