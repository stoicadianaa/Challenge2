//
//  LanternSortingView.swift
//  Challenge2
//
//  Finish the lantern pattern: fill the empty spaces from the choices, then Check.
//

import SwiftUI

struct LanternSortingView: View {

    @State private var viewModel: LanternSortingViewModel
    @Environment(\.screenSize) private var screen

    // Called when the pattern is right. The session decides what happens next.
    let onCorrect: (GameResult) -> Void

    init(game: LanternSortingGameModel, onCorrect: @escaping (GameResult) -> Void) {
        _viewModel = State(initialValue: LanternSortingViewModel(game: game))
        self.onCorrect = onCorrect
    }

    private var spacing: CGFloat { screen.isCompact ? 6 : 14 }

    // As big as the row allows: both the width and the height limit it,
    // so a long pattern shrinks instead of overflowing.
    private func tileSize(in area: CGSize, count: Int, maxSize: CGFloat) -> CGFloat {
        let byWidth = (area.width - spacing * CGFloat(count - 1)) / CGFloat(count)
        return max(32, min(maxSize, byWidth, area.height))
    }

    var body: some View {
        GameScreen(title: viewModel.game.title, coach: viewModel.coach) {
            VStack(spacing: screen.value(regular: 40, portrait: 24, landscape: 10)) {
                patternRow
                choicesRow
            }
        } footer: {
            Button("Check") { viewModel.check() }
                .buttonStyle(.glassProminent)
                .tint(.green)
                .controlSize(.extraLarge)
                .disabled(!viewModel.isComplete || viewModel.isSolved)
                .font(.title.bold())
        }
        // After the praise, let the mascot finish talking, then hand over to the session.
        // The task is cancelled automatically if the screen closes first.
        .task(id: viewModel.isSolved) {
            guard viewModel.isSolved else { return }
            await viewModel.coach.waitUntilQuiet()
            try? await Task.sleep(for: .seconds(0.5))  // a beat to enjoy the praise
            guard !Task.isCancelled else { return }
            onCorrect(GameResult(solvedFirstTry: viewModel.wrongChecks == 0))
        }
        .sensoryFeedback(.success, trigger: viewModel.isSolved) { _, solved in solved }
        .sensoryFeedback(.error, trigger: viewModel.wrongChecks) { old, new in new > old }
    }

    // The pattern, followed by the spaces the child fills.
    private var patternRow: some View {
        GeometryReader { area in
            let game = viewModel.game
            let size = tileSize(in: area.size, count: game.completed.count, maxSize: 110)

            HStack(spacing: spacing) {
                ForEach(game.shown.indices, id: \.self) { index in
                    tile(game.shown[index], size: size)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Position \(index + 1), \(game.shown[index].title)")
                }

                ForEach(viewModel.answers.indices, id: \.self) { index in
                    let answer = viewModel.answers[index]

                    Button {
                        viewModel.remove(at: index)
                    } label: {
                        tile(answer, size: size)
                    }
                    .buttonStyle(.plain)
                    .disabled(answer == nil || viewModel.isSolved)
                    .accessibilityLabel(
                        "Position \(game.shown.count + index + 1), \(answer?.title ?? "empty")"
                    )
                    .accessibilityHint(answer == nil ? "Choose a lantern below" : "Removes this lantern")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: screen.value(regular: 130, portrait: 80, landscape: 64))
    }

    private var choicesRow: some View {
        GeometryReader { area in
            let size = tileSize(in: area.size, count: Lantern.allCases.count, maxSize: 150)

            HStack(spacing: spacing * 2) {
                ForEach(Lantern.allCases) { lantern in
                    Button {
                        viewModel.place(lantern)
                    } label: {
                        tile(lantern, size: size)
                    }
                    .buttonStyle(.plain)
                    .disabled(!viewModel.canPlace)
                    .accessibilityLabel(lantern.title)
                    .accessibilityHint("Fills the first empty position")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: screen.value(regular: 170, portrait: 100, landscape: 70))
    }

    // One square: a lantern, or an empty space with a question mark.
    private func tile(_ lantern: Lantern?, size: CGFloat) -> some View {
        let shape = RoundedRectangle(cornerRadius: min(24, size * 0.2))

        return ZStack {
            if let lantern {
                LanternArtwork(lantern: lantern, glowing: viewModel.isSolved)
                    .frame(width: size * 0.78, height: size * 0.79)
            } else {
                shape
                    .strokeBorder(.secondary, style: StrokeStyle(lineWidth: 2, dash: [6, 5]))
                    .padding(7)
                Image(systemName: "questionmark")
                    .font(.system(size: size * 0.36, weight: .bold, design: .rounded))
                    .accessibilityHidden(true)
            }
        }
        .frame(width: size, height: size)
        .glassEffect(.regular, in: shape)
        .contentShape(shape)
    }
}

#Preview {
    LanternSortingView(game: LanternSortingGameModel.all[3], onCorrect: { _ in })
}
