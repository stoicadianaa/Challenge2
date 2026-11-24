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

    init(
        type: GameType,
        games: GameViewModel,
        progress: SkillProgress,
        gameCount: Int = 1,
        onProgressChange: @escaping (SkillProgress) -> Void,
        onFinish: @escaping (_ drops: Int) -> Void
    ) {
        _viewModel = State(initialValue: GameSessionViewModel(
            type: type, games: games, progress: progress, gameCount: gameCount,
            onProgressChange: onProgressChange, onFinish: onFinish))
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
            case .oddOneOut(let model):
                OddOneOutView(game: model, onCorrect: viewModel.gameCompleted)
                    .id(game.id)
            case .lanternSorting(let model):
                LanternSortingView(game: model, onCorrect: viewModel.gameCompleted)
                    .id(game.id)
            case .fruitDrag(let model):
                FruitDragView(game: model, onCorrect: viewModel.gameCompleted)
                    .id(game.id)
            case .mathMatch(let question):
                MathMatchView(question: question, onCorrect: viewModel.gameCompleted)
                    .id(game.id)
            case .wordMatch(let question):
                WordMatchView(question: question, onCorrect: viewModel.gameCompleted)
                    .id(game.id)
            case .tracing(let shape):
                TracingGameView(shape: shape, difficulty: game.difficulty, onCorrect: viewModel.gameCompleted)
                    .id(game.id)
            }
        }
    }
}
