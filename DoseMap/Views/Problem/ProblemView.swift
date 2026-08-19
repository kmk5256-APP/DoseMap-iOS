import SwiftUI

struct ProblemFlowView: View {
    let region: MapRegion
    @EnvironmentObject var progress: UserProgressManager
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var vm: ProblemViewModel
    @State private var showCelebration = false
    
    init(region: MapRegion) {
        self.region = region
        _vm = StateObject(wrappedValue: ProblemViewModel(region: region.type))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.03, green: 0.1, blue: 0.16),
                    Color(red: 0.05, green: 0.16, blue: 0.24)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: region.icon)
                            .foregroundStyle(region.color)
                        Text(region.title)
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    // Progress dots
                    Text("\(vm.currentIndex + 1)/\(vm.problemsInRegion.count)")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding()
                
                if let problem = vm.currentProblem {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Question card
                            VStack(alignment: .leading, spacing: 16) {
                                Text("PROBLEM")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundStyle(region.color)
                                    .tracking(1.2)
                                
                                Text(problem.question)
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                    .foregroundStyle(.white)
                                    .lineSpacing(4)
                            }
                            .padding(24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .stroke(region.color.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            
                            // Answer input
                            AnswerInputView(
                                answer: $vm.userAnswer,
                                unit: problem.unit,
                                accent: region.color,
                                isEnabled: !vm.showFeedback
                            )
                            
                            // Feedback
                            if vm.showFeedback {
                                FeedbackBanner(isCorrect: vm.isCorrect, accent: region.color)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                            
                            // Actions
                            VStack(spacing: 12) {
                                if !vm.showFeedback {
                                    PrimaryButton(title: "Check Answer", accent: region.color) {
                                        vm.checkAnswer()
                                        if vm.isCorrect {
                                            progress.recordSuccess(problem: problem)
                                            showCelebration = true
                                        }
                                    }
                                    .disabled(vm.userAnswer.isEmpty)
                                } else {
                                    if vm.isCorrect {
                                        PrimaryButton(title: vm.hasMoreProblems ? "Next Problem" : "Finish Region", accent: region.color) {
                                            if vm.hasMoreProblems {
                                                withAnimation { vm.nextProblem() }
                                            } else {
                                                dismiss()
                                            }
                                        }
                                    } else {
                                        PrimaryButton(title: "Try Again", accent: .orange) {
                                            withAnimation {
                                                vm.showFeedback = false
                                                vm.userAnswer = ""
                                            }
                                        }
                                        
                                        Button("Show Explanation") {
                                            vm.showExplanation = true
                                        }
                                        .font(.system(size: 15, weight: .medium, design: .rounded))
                                        .foregroundStyle(.white.opacity(0.7))
                                    }
                                }
                            }
                            .padding(.top, 8)
                        }
                        .padding(20)
                    }
                } else {
                    // Completed region
                    VStack(spacing: 24) {
                        Spacer()
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 72))
                            .foregroundStyle(region.color)
                        Text("Region Mastered!")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Great work exploring \(region.title).")
                            .foregroundStyle(.white.opacity(0.7))
                        PrimaryButton(title: "Back to Map", accent: region.color) {
                            dismiss()
                        }
                        .padding(.horizontal, 40)
                        Spacer()
                    }
                }
            }
            
            if showCelebration {
                CelebrationView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                            withAnimation { showCelebration = false }
                        }
                    }
            }
        }
        .sheet(isPresented: $vm.showExplanation) {
            if let problem = vm.currentProblem {
                ExplanationSheet(problem: problem, accent: region.color)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

struct FeedbackBanner: View {
    let isCorrect: Bool
    let accent: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.title2)
                .foregroundStyle(isCorrect ? Color.green : Color.red)
            
            Text(isCorrect ? "Correct! Well done." : "Not quite. Check your units and try again.")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(isCorrect ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
        )
    }
}
