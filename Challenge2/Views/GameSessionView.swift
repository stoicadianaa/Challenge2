//
//  GameSessionView.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 20/11/2026.
//

import SwiftUI

// Plays games one after another (easiest first), then returns home.
// Nothing is saved between sessions yet.
struct GameSessionView: View {
    // All games of the category, already sorted easy -> hard.
    let games: [Game]
    // how many games this session plays. Defaults to 1; if the category has
    // fewer games than this, it plays what exists (see `playlist`).
    var gameCount = 1
    // Tells HomeView how many drops were earned so it can update its counter.
    let onFinish: (_ drops: Int) -> Void

    @State private var index = 0
    @Environment(\.dismiss) private var dismiss

    // The games actually played in this session.
    private var playlist: [Game] {
        Array(games.prefix(gameCount))
    }

    var body: some View {
        let game = playlist[index]
        switch game.content {
        case .ordering(let model):
            OrderingGame(game: model, onCorrect: next)
                .id(game.id)
        }
    }

    private func next() {
        if index + 1 < playlist.count {
            index += 1
        } else {
            // One drop per game.
            onFinish(playlist.count)
            // TODO: show the reward screen here, then go back to the home screen.
            dismiss()
        }
    }
}
