import SwiftUI

struct RegionDetailSheet: View {
    let region: MapRegion
    @Binding var showProblem: Bool
    @EnvironmentObject var progress: UserProgressManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // Header icon
                HStack {
                    ZStack {
                        Circle()
                            .fill(region.color.opacity(0.2))
                            .frame(width: 64, height: 64)
                        Image(systemName: region.icon)
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(region.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(region.title)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        HStack(spacing: 4) {
                            ForEach(0..<3, id: \.self) { i in
                                Image(systemName: i < progress.stars(for: region.type) ? "star.fill" : "star")
                                    .foregroundStyle(i < progress.stars(for: region.type) ? .yellow : .secondary)
                            }
                            Text("\(progress.stars(for: region.type))/3 mastery")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                }
                
                Text(region.description)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                let problems = CalculationProblem.problems(for: region.type)
                Text("\(problems.count) practice problems available")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                PrimaryButton(title: "Start Practicing", accent: region.color) {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showProblem = true
                    }
                }
            }
            .padding(24)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
