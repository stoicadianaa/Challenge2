//
//  GameSessionViewModel.swift
//  Challenge2
//
//  Runs one play session: which game is current, when the session is over and
//  how many drops it earned. The view only shows the current screen.
//

import Foundation
import Observation

@MainActor
@Observable
final class GameSessionViewModel {
    // The games actually played: the first `gameCount` of the category, easy -> hard.
    private let playlist: [Game]
    // Tells the home screen how many drops were earned so it can update its counter.
    @ObservationIgnored private let onFinish: (Int) -> Void

    private(set) var index = 0
    private(set) var isFinished = false

    /// - Parameters:
    ///   - games: all games of the category, already sorted easy -> hard.
    ///   - gameCount: how many games this session plays. If the category has
    ///     fewer, it plays what exists.
    init(games: [Game], gameCount: Int = 1, onFinish: @escaping (_ drops: Int) -> Void) {
        self.playlist = Array(games.prefix(gameCount))
        self.onFinish = onFinish
    }

    /// The game to show, or nil when the session is over (or has no games).
    var currentGame: Game? {
        guard !isFinished, playlist.indices.contains(index) else { return nil }
        return playlist[index]
    }

    /// What this session is worth: the sum of what each game declares.
    var dropsEarned: Int {
        playlist.map(\.drops).reduce(0, +)
    }

    /// Call when the child solves the current game.
    func gameCompleted() {
        guard !isFinished else { return }
        if index + 1 < playlist.count {
            index += 1
        } else {
            isFinished = true
            // Added now, not on Continue, so leaving the reward screen can't lose it.
            onFinish(dropsEarned)
        }
    }
}
