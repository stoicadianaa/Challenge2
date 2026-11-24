//
//  FruitDragView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 23/11/2026.
//

import SwiftUI

struct FruitDragView: View {

    @State private var viewModel: FruitDragViewModel
    @Environment(\.screenSize) private var screen

    // Called when the child finds the right fruit. The session decides what happens next.
    let onCorrect: (GameResult) -> Void

    init(game: FruitDragGameModel, onCorrect: @escaping (GameResult) -> Void) {
        _viewModel = State(initialValue: FruitDragViewModel(game: game))
        self.onCorrect = onCorrect
    }

    private var letterSize: CGFloat { screen.value(regular: 100, portrait: 72, landscape: 44) }
    private var fruitSize: CGFloat { screen.value(regular: 90, portrait: 52, landscape: 40) }

    var body: some View {
        GameScreen(title: viewModel.title, coach: viewModel.coach) {
            VStack(spacing: screen.value(regular: 48, portrait: 32, landscape: 12)) {
                letterZone
                fruits
            }
            .coordinateSpace(.named(FruitTile.coordinateSpace))
        } footer: {
            EmptyView()
        }
        // After the fruit is on the letter, let the mascot finish talking, then hand over to the session.
        // The task is cancelled automatically if the screen closes first.
        .task(id: viewModel.isSolved) {
            guard viewModel.isSolved else { return }
            await viewModel.coach.waitUntilQuiet()
            try? await Task.sleep(for: .seconds(0.5))  // a beat to enjoy the praise
            guard !Task.isCancelled else { return }
            onCorrect(GameResult(solvedFirstTry: viewModel.wrongCount == 0))
        }
        .sensoryFeedback(.success, trigger: viewModel.isSolved) { _, solved in solved }
        .sensoryFeedback(.error, trigger: viewModel.wrongCount) { old, new in new > old }
    }

    private var letterZone: some View {
        Text(viewModel.letter)
            .font(.system(size: letterSize, weight: .heavy, design: .rounded))
            .frame(width: letterSize * 1.8, height: letterSize * 1.8)
            .glassEffect(.regular.tint(zoneTint), in: .circle)
            .scaleEffect(viewModel.isHoveringLetter ? 1.1 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.isHoveringLetter)
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .named(FruitTile.coordinateSpace))
            } action: { frame in
                viewModel.letterFrame = frame
            }
            .accessibilityLabel("Letter \(viewModel.letter)")
    }

    // The letter turns green when a fruit is over it and when the game is solved
    private var zoneTint: Color {
        viewModel.isSolved || viewModel.isHoveringLetter ? .green.opacity(0.5) : .orange.opacity(0.3)
    }

    private var fruits: some View {
        HStack(spacing: screen.value(regular: 36, portrait: 12, landscape: 20)) {
            ForEach(viewModel.game.options) { fruit in
                FruitTile(
                    fruit: fruit,
                    isSolved: viewModel.isSolved,
                    isTarget: viewModel.game.isTarget(fruit),
                    onMove: { viewModel.dragMoved(to: $0) },
                    onDrop: { viewModel.dropped(fruit, at: $0) },
                    onChoose: { _ = viewModel.choose(fruit) }
                )
            }
        }
        .font(.system(size: fruitSize))
    }
}

#Preview {
    FruitDragView(game: FruitDragGameModel.all[0], onCorrect: { _ in })
}
