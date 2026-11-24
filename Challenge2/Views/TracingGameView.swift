//
//  TracingGameView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//


import SwiftUI

struct TracingGameView: View {

    @State private var viewModel: TracingGameViewModel

    // Called when the shape is traced. The session decides what happens next.
    let onCorrect: (GameResult) -> Void

    init(shape: TraceShape, difficulty: Difficulty, onCorrect: @escaping (GameResult) -> Void) {
        _viewModel = State(initialValue: TracingGameViewModel(shape: shape, difficulty: difficulty))
        self.onCorrect = onCorrect
    }

    var body: some View {
        GameScreen(
            title: "Trace the \(viewModel.shape.title)!",
            coach: viewModel.coach,
            expandsContent: true
        ) {
            // The drawing area takes all the room; the reference card sits in its corner.
            TraceDrawingArea(viewModel: viewModel)
                .overlay(alignment: .topTrailing) {
                    TraceReferenceCard(shape: viewModel.shape)
                        .padding(16)
                        .allowsHitTesting(false)  // never blocks drawing underneath
                }
        } footer: {
            TracePaletteBar(viewModel: viewModel)
        }
        // After the shape is traced, let the mascot finish praising, then hand over to the session.
        .task(id: viewModel.isCompleted) {
            guard viewModel.isCompleted else { return }
            await viewModel.coach.waitUntilQuiet()
            try? await Task.sleep(for: .seconds(0.5))
            guard !Task.isCancelled else { return }
            onCorrect(GameResult(solvedFirstTry: viewModel.solvedFirstTry))
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(viewModel.isCompleted)
        .sensoryFeedback(.success, trigger: viewModel.isCompleted) { _, completed in completed }
    }
}

#Preview(traits: .landscapeLeft) {
    NavigationStack {
        TracingGameView(shape: .star, difficulty: .medium, onCorrect: { _ in })
    }
}
