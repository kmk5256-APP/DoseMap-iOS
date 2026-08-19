import SwiftUI

struct AnswerInputView: View {
    @Binding var answer: String
    let unit: String
    let accent: Color
    let isEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("YOUR ANSWER")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(accent)
                .tracking(1.2)
            
            HStack(spacing: 12) {
                TextField("0", text: $answer)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(accent.opacity(0.4), lineWidth: 1.5)
                            )
                    )
                    .disabled(!isEnabled)
                
                Text(unit)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
                    .frame(width: 90)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(accent.opacity(0.2))
                    )
            }
        }
    }
}
