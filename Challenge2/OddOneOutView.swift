//
//  OddOneOutView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import SwiftUI

struct OddOneOutView: View {

    @State private var viewModel: OddOneOutViewModel
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled

    init(game: OddOneOutGameModel, onCorrect: @escaping () -> Void) {
        _viewModel = State(initialValue: OddOneOutViewModel(game: game, onCorrect: onCorrect))
    }

    var body: some View {
        content
            .background { backgroundImage }
            .sensoryFeedback(.success, trigger: viewModel.isSolved) { _, solved in solved }
            .sensoryFeedback(.error, trigger: viewModel.wrongTiles.count) { old, new in new > old }
            .onAppear {
                guard !voiceOverEnabled else { return }
                viewModel.speakInstruction()
            }
            .onDisappear { viewModel.stop() }
    }


    private var content: some View {
        VStack {
            Spacer()

            instruction

            Spacer()

            tiles

            Spacer()

            bottomRow
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 8)
        .fontDesign(.rounded)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var backgroundImage: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .accessibilityHidden(true)
    }

    // Tapping the button reads the instruction aloud
    private var instruction: some View {
        Button(viewModel.game.title, systemImage: "speaker.wave.2.fill") {
            viewModel.speakInstruction()
        }
        .font(.largeTitle.bold())
        .buttonStyle(.glass)
        .controlSize(.extraLarge)
    }

    // MARK: The four tiles

    private var tiles: some View {
        HStack(spacing: 28) {
            ForEach(0..<OddOneOutGameModel.tileCount, id: \.self) { index in
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
        .font(.system(size: 110))
    }

    private var bottomRow: some View {
        HStack(alignment: .bottom, spacing: 16) {
            Image(viewModel.mascotImage)
                .resizable()
                .scaledToFit()
                .frame(height: 170)
                .accessibilityHidden(true)

            SpeechBubble {
                Text(viewModel.feedback)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.primary)
                    .animation(.default, value: viewModel.feedback)
            }
            .padding(.bottom, 40)
        }
    }
}

#Preview() {
    OddOneOutView(game: OddOneOutGameModel.all[0], onCorrect: {})
}
