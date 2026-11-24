//
//  SkillProgress.swift
//  Challenge2
//
//  A child's progress in ONE category (GameType): current level, streaks, and
//  which games they played recently. Stored inside ChildProfile.
//

import Foundation

struct SkillProgress: Codable, Equatable {
    static let winsToLevelUp = 3
    static let strugglesToLevelDown = 2

    var level: Difficulty = .easy
    var winStreak = 0
    var struggleStreak = 0
    /// Stable keys of recently played games, so the same one isn't served twice in a row.
    var recentlyPlayed: [String] = []

    /// Remembers a game as the most recently played. Each key appears once.
    mutating func markPlayed(_ key: String) {
        recentlyPlayed.removeAll { $0 == key }
        recentlyPlayed.append(key)
    }

    /// Updates streaks and level after one game.
    mutating func record(_ result: GameResult) {
        if result.solvedFirstTry {
            winStreak += 1
            struggleStreak = 0
            if winStreak >= Self.winsToLevelUp {
                // Already at the top: keep the streak at 0 and stay on Hard.
                if let next = Difficulty(rawValue: level.rawValue + 1) { level = next }
                winStreak = 0
            }
        } else {
            struggleStreak += 1
            winStreak = 0
            if struggleStreak >= Self.strugglesToLevelDown {
                if let previous = Difficulty(rawValue: level.rawValue - 1) { level = previous }
                struggleStreak = 0
            }
        }
    }
}
