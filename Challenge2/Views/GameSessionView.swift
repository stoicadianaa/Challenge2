//
//  GameSessionView.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 20/11/2026.
//

import SwiftUI

// Shows the current game of a session, then the reward screen, then returns home.
// All the session logic lives in GameSessionViewModel.
struct GameSessionView: View {
    @State private var viewModel: GameSessionViewModel
    @Environment(\.dismiss) private var dismiss

    // Same parameters as before, so HomeView doesn't change.
    init(games: [Game], gameCount: Int = 1, onFinish: @escaping (_ drops: Int) -> Void) {
        _viewModel = State(initialValue: GameSessionViewModel(
            games: games, gameCount: gameCount, onFinish: onFinish))
    }

    var body: some View {
        if viewModel.isFinished {
            RewardScreen(drops: viewModel.dropsEarned, onContinue: { dismiss() })
                // Nothing to go back to: the games are done, Continue returns home.
                .navigationBarBackButtonHidden(true)
        } else if let game = viewModel.currentGame {
            switch game.content {
            case .ordering(let model):
                OrderingGame(game: model, onCorrect: viewModel.gameCompleted)
                    .id(game.id)
            }
        }
    }
}
