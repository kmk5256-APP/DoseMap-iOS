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
            // Deep background
            LinearGradient(
                colors: [
                    Color(red: 0.025, green: 0.09, blue: 0.145),
                    Color(red: 0.04, green: 0.14, blue: 0.22)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header bar
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.white.opacity(0.55))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: region.icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(region.color)
                        Text(region.title)
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(region.color.opacity(0.15))
                            .overlay(
                                Capsule()
                                    .stroke(region.color.opacity(0.3), lineWidth: 1)
                            )
                    )
                    
                    Spacer()
                    
                    Text("\(min(vm.currentIndex + 1, vm.problemsInRegion.count))/\(vm.problemsInRegion.count)")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(width: 48, alignment: .trailing)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                
                if let problem = vm.currentProblem {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 28) {
                            // Question card
                            VStack(alignment: .leading, spacing: 14) {
                                Text("PROBLEM")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundStyle(region.color)
                                    .tracking(1.4)
                                
                                Text(problem.question)
                                    .font(.system(size: 19, weight: .medium, design: .rounded))
                                    .foregroundStyle(.white)
                                    .lineSpacing(5)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(22)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        region.color.opacity(0.45),
                                                        region.color.opacity(0.12)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1.2
                                            )
                                    )
                            )
                            .shadow(color: region.color.opacity(0.12), radius: 16, y: 8)
                            
                            // Answer input
                            AnswerInputView(
                                answer: $vm.userAnswer,
                                unit: problem.unit,
                                accent: region.color,
                                isEnabled: !vm.showFeedback
                            )
                            
                            // Feedback banner
                            if vm.showFeedback {
                                FeedbackBanner(isCorrect: vm.isCorrect, accent: region.color)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .bottom).combined(with: .opacity),
                                        removal: .opacity
                                    ))
                            }
                            
                            // Action buttons
                            VStack(spacing: 14) {
                                if !vm.showFeedback {
                                    PrimaryButton(title: "Check Answer", accent: region.color) {
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                            vm.checkAnswer()
                                        }
                                        if vm.isCorrect {
                                            progress.recordSuccess(problem: problem)
                                            showCelebration = true
                                        }
                                    }
                                    .disabled(vm.userAnswer.trimmingCharacters(in: .whitespaces).isEmpty)
                                    .opacity(vm.userAnswer.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1.0)
                                } else {
                                    if vm.isCorrect {
                                        PrimaryButton(
                                            title: vm.hasMoreProblems ? "Next Problem" : "Finish Region",
                                            accent: region.color
                                        ) {
                                            if vm.hasMoreProblems {
                                                withAnimation(.easeInOut(duration: 0.3)) {
                                                    vm.nextProblem()
                                                }
                                            } else {
                                                dismiss()
                                            }
                                        }
                                    } else {
                                        PrimaryButton(title: "Try Again", accent: Color.orange) {
                                            withAnimation {
                                                vm.showFeedback = false
                                                vm.userAnswer = ""
                                            }
                                        }
                                        
                                        Button {
                                            vm.showExplanation = true
                                        } label: {
                                            Text("Show Explanation")
                                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                                .foregroundStyle(.white.opacity(0.7))
                                        }
                                        .padding(.top, 4)
                                    }
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                    }
                } else {
                    // Region complete state
                    VStack(spacing: 28) {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(region.color.opacity(0.15))
                                .frame(width: 140, height: 140)
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 64))
                                .foregroundStyle(region.color)
                                .symbolEffect(.bounce, value: true)
                        }
                        
                        VStack(spacing: 10) {
                            Text("Region Mastered!")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            Text("Great work exploring \(region.title).")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.65))
                        }
                        
                        PrimaryButton(title: "Back to Map", accent: region.color) {
                            dismiss()
                        }
                        .padding(.horizontal, 48)
                        .padding(.top, 12)
                        
                        Spacer()
                    }
                }
            }
            
            // Celebration overlay
            if showCelebration {
                CelebrationView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeOut(duration: 0.4)) {
                                showCelebration = false
                            }
                        }
                    }
                    .allowsHitTesting(false)
            }
        }
        .sheet(isPresented: $vm.showExplanation) {
            if let problem = vm.currentProblem {
                ExplanationSheet(problem: problem, accent: region.color)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

struct FeedbackBanner: View {
    let isCorrect: Bool
    let accent: Color
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 24))
                .foregroundStyle(isCorrect ? Color.green : Color.red)
            
            Text(isCorrect ? "Correct! Well done." : "Not quite. Check your units and try again.")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
            
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(isCorrect ? Color.green.opacity(0.18) : Color.red.opacity(0.18))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(isCorrect ? Color.green.opacity(0.35) : Color.red.opacity(0.35), lineWidth: 1)
                )
        )
    }
}
