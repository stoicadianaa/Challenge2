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
        VStack(spacing: 16) {
            TraceReferenceCard(shape: viewModel.shape)
            TracePaletteBar(viewModel: viewModel)
            TraceDrawingArea(viewModel: viewModel)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .background {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .accessibilityHidden(true)
        }
        .mascotOverlay(viewModel.coach)
        // After the shape is traced, let the mascot finish praising, then hand over to the session.
        .task(id: viewModel.isCompleted) {
            guard viewModel.isCompleted else { return }
            await viewModel.coach.waitUntilQuiet()
            try? await Task.sleep(for: .seconds(0.5))
            guard !Task.isCancelled else { return }
            onCorrect(GameResult(solvedFirstTry: viewModel.solvedFirstTry))
        }
        .navigationTitle("Trace & Draw")
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
