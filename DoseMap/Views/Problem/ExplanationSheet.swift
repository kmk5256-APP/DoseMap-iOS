import SwiftUI

struct ExplanationSheet: View {
    let problem: CalculationProblem
    let accent: Color
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Correct answer highlight
                    HStack {
                        Text("Correct Answer")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(format(problem.correctAnswer)) \(problem.unit)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(accent)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14).fill(accent.opacity(0.12)))
                    
                    // Steps
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Step-by-Step")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        
                        ForEach(Array(problem.steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 14) {
                                Text("\(index + 1)")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                    .frame(width: 28, height: 28)
                                    .background(Circle().fill(accent))
                                
                                Text(step)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundStyle(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    
                    // Tip
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Pro Tip", systemImage: "lightbulb.fill")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.yellow)
                        
                        Text(problem.tip)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.yellow.opacity(0.1)))
                }
                .padding(24)
            }
            .navigationTitle("Explanation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private func format(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value))
        }
        return String(format: "%.1f", value)
    }
}
