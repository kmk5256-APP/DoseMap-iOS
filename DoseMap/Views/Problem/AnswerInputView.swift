import SwiftUI

struct AnswerInputView: View {
    @Binding var answer: String
    let unit: String
    let accent: Color
    let isEnabled: Bool
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("YOUR ANSWER")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(accent)
                .tracking(1.4)
            
            HStack(spacing: 12) {
                TextField("0", text: $answer)
                    .accessibilityLabel("Numeric answer in \(unit)")
                    .keyboardType(.decimalPad)
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 18)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.white.opacity(0.07))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(
                                        isFocused ? accent.opacity(0.7) : accent.opacity(0.35),
                                        lineWidth: isFocused ? 2 : 1.5
                                    )
                            )
                    )
                    .focused($isFocused)
                    .disabled(!isEnabled)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)
                
                Text(unit)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.85))
                    .frame(minWidth: 78)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [accent.opacity(0.28), accent.opacity(0.15)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(accent.opacity(0.35), lineWidth: 1)
                            )
                    )
            }
        }
    }
}
