//
//  GameSessionViewModel.swift
//  Challenge2
//
//  Runs one play session in one category: picks each game from the child's
//  current level, records how it went, and ends after `gameCount` games.
//  The view only shows the current screen.
//

import Foundation
import Observation

@MainActor
@Observable
final class GameSessionViewModel {
    private let type: GameType
    private let games: GameViewModel
    private let gameCount: Int
    // Tell the owner of the profile to save the new progress / add the earned drops.
    @ObservationIgnored private let onProgressChange: (SkillProgress) -> Void
    @ObservationIgnored private let onFinish: (Int) -> Void

    private(set) var progress: SkillProgress
    private(set) var currentGame: Game?
    private(set) var gamesPlayed = 0
    private(set) var dropsEarned = 0
    private(set) var isFinished = false

    /// - Parameters:
    ///   - progress: the child's progress in this category.
    ///   - gameCount: how many games this session plays.
    init(
        type: GameType,
        games: GameViewModel,
        progress: SkillProgress,
        gameCount: Int = 1,
        onProgressChange: @escaping (SkillProgress) -> Void,
        onFinish: @escaping (_ drops: Int) -> Void
    ) {
        self.type = type
        self.games = games
        self.progress = progress
        self.gameCount = gameCount
        self.onProgressChange = onProgressChange
        self.onFinish = onFinish
        self.currentGame = games.nextGame(type: type, progress: progress)
        // A category with no games has nothing to play.
        if currentGame == nil { isFinished = true }
    }

    /// Call when the child solves the current game.
    func gameCompleted(_ result: GameResult) {
        guard !isFinished, let game = currentGame else { return }

        // Level changes now, so the next game of this session already uses it.
        progress.record(result)
        progress.markPlayed(game.key)
        onProgressChange(progress)

        dropsEarned += game.drops
        gamesPlayed += 1

        if gamesPlayed < gameCount, let next = games.nextGame(type: type, progress: progress) {
            currentGame = next
        } else {
            currentGame = nil
            isFinished = true
            // Added now, not on Continue, so leaving the reward screen can't lose it.
            onFinish(dropsEarned)
        }
    }
}
