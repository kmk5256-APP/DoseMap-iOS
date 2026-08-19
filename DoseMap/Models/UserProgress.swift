import Foundation
import SwiftUI
import Combine

@MainActor
class UserProgressManager: ObservableObject {
    @Published var stars: [RegionType: Int] = [:]
    @Published var completedProblemIDs: Set<UUID> = []
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
        
        // Award star progress (max 3 per region)
        let current = stars[problem.region] ?? 0
        if current < 3 {
            // Simple: every 2 unique problems in region = +1 star (capped)
            let regionProblems = CalculationProblem.problems(for: problem.region)
            let solvedInRegion = regionProblems.filter { completedProblemIDs.contains($0.id) }.count
            let newStars = min(3, solvedInRegion / 2 + (solvedInRegion > 0 ? 1 : 0))
            stars[problem.region] = max(current, newStars)
        }
        
        // Streak
        let calendar = Calendar.current
        if let last = lastPracticeDate, calendar.isDateInToday(last) {
            // already practiced today
        } else if let last = lastPracticeDate, calendar.isDateInYesterday(last) {
            currentStreak += 1
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
    
    private func save() {
        // Simple persistence
        if let data = try? JSONEncoder().encode(stars.mapKeys { $0.rawValue }) {
            defaults.set(data, forKey: "stars")
        }
        defaults.set(Array(completedProblemIDs.map { $0.uuidString }), forKey: "completed")
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
            completedProblemIDs = Set(ids.compactMap { UUID(uuidString: $0) })
        }
        currentStreak = defaults.integer(forKey: "streak")
        lastPracticeDate = defaults.object(forKey: "lastDate") as? Date
        hasCompletedOnboarding = defaults.bool(forKey: "onboarding")
        totalProblemsSolved = defaults.integer(forKey: "totalSolved")
    }
}

// Helpers
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
