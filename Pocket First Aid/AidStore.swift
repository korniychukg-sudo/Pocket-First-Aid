import Foundation
import SwiftUI

/// Persistent app state: kit checklists, quiz records, onboarding flag.
final class AidStore: ObservableObject {
    @Published private(set) var checkedKitItems: [String: Set<Int>]  // kit id -> checked indices
    @Published private(set) var quizBestScore: Int
    @Published private(set) var quizRounds: Int
    @Published private(set) var topicsOpened: Set<String>

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let kits = "aid.kitChecks"
        static let best = "aid.quizBest"
        static let rounds = "aid.quizRounds"
        static let opened = "aid.topicsOpened"
    }

    init() {
        if let data = defaults.data(forKey: Keys.kits),
           let decoded = try? JSONDecoder().decode([String: Set<Int>].self, from: data) {
            checkedKitItems = decoded
        } else {
            checkedKitItems = [:]
        }
        quizBestScore = defaults.integer(forKey: Keys.best)
        quizRounds = defaults.integer(forKey: Keys.rounds)
        topicsOpened = Set(defaults.stringArray(forKey: Keys.opened) ?? [])
    }

    // MARK: - Kits

    func isChecked(kit: String, index: Int) -> Bool {
        checkedKitItems[kit]?.contains(index) ?? false
    }

    func toggle(kit: String, index: Int) {
        var set = checkedKitItems[kit] ?? []
        if set.contains(index) {
            set.remove(index)
        } else {
            set.insert(index)
        }
        checkedKitItems[kit] = set
        persistKits()
    }

    func checkedCount(kit: String) -> Int {
        checkedKitItems[kit]?.count ?? 0
    }

    func resetKit(_ kit: String) {
        checkedKitItems[kit] = []
        persistKits()
    }

    // MARK: - Quiz

    func recordQuiz(score: Int) {
        quizRounds += 1
        if score > quizBestScore {
            quizBestScore = score
        }
        defaults.set(quizBestScore, forKey: Keys.best)
        defaults.set(quizRounds, forKey: Keys.rounds)
    }

    // MARK: - Reading progress

    func markOpened(_ topicID: String) {
        guard !topicsOpened.contains(topicID) else { return }
        topicsOpened.insert(topicID)
        defaults.set(Array(topicsOpened), forKey: Keys.opened)
    }

    private func persistKits() {
        if let data = try? JSONEncoder().encode(checkedKitItems) {
            defaults.set(data, forKey: Keys.kits)
        }
    }
}
