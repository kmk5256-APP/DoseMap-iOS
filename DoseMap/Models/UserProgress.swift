import Foundation
import SwiftUI
import Combine

@MainActor
class UserProgressManager: ObservableObject {
    @Published var stars: [RegionType: Int] = [:]
    @Published var completedProblemIDs: Set<String> = []
    @Published var currentStreak: Int = 0
    @Published var lastPracticeDate: Date? = nil
    @Published var hasCompletedOnboarding: Bool = false
    @Published var totalProblemsSolved: Int = 0
    
    private let defaults = UserDefaults.standard
    
    init() {
        load()
    }
    
    var totalStars: Int {
        stars.values.reduce(0, +)
    }
    
    func stars(for region: RegionType) -> Int {
        stars[region] ?? 0
    }
    
    func isUnlocked(_ region: RegionType) -> Bool {
        totalStars >= region.requiredStarsToUnlock
    }
    
    func recordSuccess(problem: CalculationProblem) {
        guard !completedProblemIDs.contains(problem.id) else { return }
        
        completedProblemIDs.insert(problem.id)
        totalProblemsSolved += 1
        
        // Improved mastery: 1 star after first solve, 2 after ~half, 3 when most/all done
        let regionProblems = CalculationProblem.problems(for: problem.region)
        let solvedInRegion = regionProblems.filter { completedProblemIDs.contains($0.id) }.count
        let totalInRegion = max(regionProblems.count, 1)
        
        let ratio = Double(solvedInRegion) / Double(totalInRegion)
        var newStars = 0
        if solvedInRegion >= 1 { newStars = 1 }
        if ratio >= 0.45 || solvedInRegion >= 3 { newStars = 2 }
        if ratio >= 0.8 || solvedInRegion >= 5 { newStars = 3 }
        
        let current = stars[problem.region] ?? 0
        stars[problem.region] = max(current, newStars)
        
        // Streak tracking
        let calendar = Calendar.current
        if let last = lastPracticeDate {
            if calendar.isDateInToday(last) {
                // already counted today
            } else if calendar.isDateInYesterday(last) {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }
        lastPracticeDate = Date()
        
        save()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        save()
    }

#if DEBUG
    func seedForScreenshots() {
        let solved = Array(CalculationProblem.allProblems.prefix(14))
        completedProblemIDs = Set(solved.map(\.id))
        totalProblemsSolved = solved.count
        stars = [.oral: 3, .conversion: 3, .ivFlow: 2, .weight: 2, .drip: 1]
        currentStreak = 7
        hasCompletedOnboarding = true
    }
#endif
    
    private func save() {
        if let data = try? JSONEncoder().encode(stars.mapKeys { $0.rawValue }) {
            defaults.set(data, forKey: "stars")
        }
        defaults.set(Array(completedProblemIDs), forKey: "completed")
        defaults.set(currentStreak, forKey: "streak")
        defaults.set(lastPracticeDate, forKey: "lastDate")
        defaults.set(hasCompletedOnboarding, forKey: "onboarding")
        defaults.set(totalProblemsSolved, forKey: "totalSolved")
    }
    
    private func load() {
        if let data = defaults.data(forKey: "stars"),
           let dict = try? JSONDecoder().decode([String: Int].self, from: data) {
            stars = dict.compactMapKeys { RegionType(rawValue: $0) }
        }
        if let ids = defaults.array(forKey: "completed") as? [String] {
            // Older prerelease builds stored random UUIDs that could never match
            // after relaunch. Only retain IDs from the stable current question bank.
            let validIDs = Set(CalculationProblem.allProblems.map(\.id))
            completedProblemIDs = Set(ids).intersection(validIDs)
        }
        currentStreak = defaults.integer(forKey: "streak")
        lastPracticeDate = defaults.object(forKey: "lastDate") as? Date
        hasCompletedOnboarding = defaults.bool(forKey: "onboarding")
        totalProblemsSolved = defaults.integer(forKey: "totalSolved")
    }
}

private extension Dictionary {
    func mapKeys<T>(_ transform: (Key) -> T) -> [T: Value] {
        var result: [T: Value] = [:]
        for (k, v) in self {
            result[transform(k)] = v
        }
        return result
    }
    
    func compactMapKeys<T>(_ transform: (Key) -> T?) -> [T: Value] {
        var result: [T: Value] = [:]
        for (k, v) in self {
            if let newKey = transform(k) {
                result[newKey] = v
            }
        }
        return result
    }
}
