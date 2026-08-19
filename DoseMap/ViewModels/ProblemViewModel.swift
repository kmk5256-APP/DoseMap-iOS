import Foundation
import SwiftUI

@MainActor
class ProblemViewModel: ObservableObject {
    @Published var currentProblem: CalculationProblem?
    @Published var userAnswer: String = ""
    @Published var selectedUnit: String = ""
    @Published var showFeedback = false
    @Published var isCorrect = false
    @Published var showExplanation = false
    @Published var problemsInRegion: [CalculationProblem] = []
    @Published var currentIndex = 0
    
    let region: RegionType
    
    init(region: RegionType) {
        self.region = region
        self.problemsInRegion = CalculationProblem.problems(for: region).shuffled()
        loadNext()
    }
    
    func loadNext() {
        guard currentIndex < problemsInRegion.count else {
            currentProblem = nil
            return
        }
        currentProblem = problemsInRegion[currentIndex]
        userAnswer = ""
        selectedUnit = currentProblem?.unit ?? ""
        showFeedback = false
        isCorrect = false
        showExplanation = false
    }
    
    func checkAnswer() {
        guard let problem = currentProblem,
              let value = Double(userAnswer.replacingOccurrences(of: ",", with: ".")) else {
            return
        }
        
        isCorrect = problem.isCorrect(value)
        showFeedback = true
        
        if isCorrect {
            // Will be recorded by the view via progress manager
        }
    }
    
    func nextProblem() {
        currentIndex += 1
        loadNext()
    }
    
    var hasMoreProblems: Bool {
        currentIndex < problemsInRegion.count - 1 || (currentProblem != nil && currentIndex < problemsInRegion.count)
    }
}
