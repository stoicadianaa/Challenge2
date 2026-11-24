//
//  OddOneOutView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import SwiftUI

struct OddOneOutView: View {

    @State private var viewModel: OddOneOutViewModel
    @Environment(\.screenSize) private var screen

    // Called when the child finds the odd one. The session decides what happens next.
    let onCorrect: (GameResult) -> Void

    init(game: OddOneOutGameModel, onCorrect: @escaping (GameResult) -> Void) {
        _viewModel = State(initialValue: OddOneOutViewModel(game: game))
        self.onCorrect = onCorrect
    }

    private var spacing: CGFloat { screen.isCompact ? 12 : 28 }

    // Tiles per row: all of them in one row, except on an upright phone where 3 fit.
    private var columnCount: Int {
        screen.isPhonePortrait ? min(3, viewModel.game.tileCount) : viewModel.game.tileCount
    }

    // As big as the area allows. Both the width and the height limit it,
    // so 6 tiles shrink their emoji instead of overflowing.
    private func emojiSize(in area: CGSize) -> CGFloat {
        let columns = CGFloat(columnCount)
        let rows = (CGFloat(viewModel.game.tileCount) / columns).rounded(.up)
        let padding = OddOneOutTile.padding(for: screen)
        let tileWidth = (area.width - spacing * (columns - 1)) / columns
        let tileHeight = (area.height - spacing * (rows - 1)) / rows
        let byWidth = (tileWidth - padding * 2) / 1.25
        let byHeight = (tileHeight - padding * 2) / 1.25
        return max(24, min(150, byWidth, byHeight))
    }

    var body: some View {
        GameScreen(title: viewModel.game.title, coach: viewModel.coach) {
            tiles
        } footer: {
            EmptyView()
        }
        // After the cross is drawn, let the mascot finish talking, then hand over to the session.
        // The task is cancelled automatically if the screen closes first.
        .task(id: viewModel.isSolved) {
            guard viewModel.isSolved else { return }
            await viewModel.coach.waitUntilQuiet()
            try? await Task.sleep(for: .seconds(0.5))  // a beat to enjoy the praise
            guard !Task.isCancelled else { return }
            onCorrect(GameResult(solvedFirstTry: viewModel.wrongTiles.isEmpty))
        }
        .sensoryFeedback(.success, trigger: viewModel.isSolved) { _, solved in solved }
        .sensoryFeedback(.error, trigger: viewModel.wrongTiles.count) { old, new in new > old }
    }

    private var tiles: some View {
        GeometryReader { area in
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnCount),
                spacing: spacing
            ) {
                ForEach(0..<viewModel.game.tileCount, id: \.self) { index in
                    OddOneOutTile(
                        emoji: viewModel.game.item(at: index).emoji,
                        tint: viewModel.game.tint,
                        isOdd: index == viewModel.game.oddIndex,
                        isSolved: viewModel.isSolved,
                        isWrong: viewModel.wrongTiles.contains(index),
                        shakes: viewModel.shakes[index, default: 0]
                    ) {
                        viewModel.tap(index)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(.system(size: emojiSize(in: area.size)))
        }
        .frame(height: screen.value(regular: 320, portrait: 300, landscape: 150))
    }
}

#Preview {
    OddOneOutView(game: OddOneOutGameModel.all[0], onCorrect: { _ in })
}
