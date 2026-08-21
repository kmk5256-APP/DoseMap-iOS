import Foundation
import Darwin

@main
struct ValidateDoseMapContent {
    static func main() {
        let problems = CalculationProblem.allProblems
        var failures: [String] = []

        if problems.count < 24 {
            failures.append("Expected at least 24 launch problems; found \(problems.count)")
        }

        let ids = problems.map(\.id)
        if Set(ids).count != ids.count {
            failures.append("Problem identifiers are not unique")
        }

        for region in RegionType.allCases where CalculationProblem.problems(for: region).isEmpty {
            failures.append("\(region.rawValue) has no problems")
        }

        for problem in problems {
            if problem.question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                failures.append("A problem has an empty question")
            }
            if problem.unit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                failures.append("\(problem.id) has no answer unit")
            }
            if problem.steps.isEmpty {
                failures.append("\(problem.id) has no worked explanation")
            }
            if problem.acceptableTolerance <= 0 {
                failures.append("\(problem.id) has a non-positive tolerance")
            }
            if !(1...3).contains(problem.difficulty) {
                failures.append("\(problem.id) has invalid difficulty \(problem.difficulty)")
            }
        }

        let zeroStarRegions = RegionType.allCases.filter { $0.requiredStarsToUnlock == 0 }
        if zeroStarRegions.count < 2 {
            failures.append("At least two regions must be available on first launch")
        }

        if failures.isEmpty {
            print("PASS: \(problems.count) unique problems across \(RegionType.allCases.count) regions")
        } else {
            failures.forEach { print("FAIL: \($0)") }
            exit(1)
        }
    }
}
