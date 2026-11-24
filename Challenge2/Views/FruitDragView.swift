//
//  FruitDragView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 23/11/2026.
//

import SwiftUI

struct FruitDragView: View {

    @State private var viewModel: FruitDragViewModel
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled

    @ScaledMetric(relativeTo: .largeTitle) private var letterSize: CGFloat = 100
    @ScaledMetric(relativeTo: .largeTitle) private var fruitSize: CGFloat = 90

    // Called when the child finds the right fruit. The session decides what happens next.
    init(game: FruitDragGameModel, onCorrect: @escaping () -> Void) {
        _viewModel = State(initialValue: FruitDragViewModel(game: game, onCorrect: onCorrect))
    }

    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .accessibilityHidden(true)
            
            content
                .sensoryFeedback(.success, trigger: viewModel.isSolved) { _, solved in solved }
                .sensoryFeedback(.error, trigger: viewModel.wrongCount) { old, new in new > old }
                .onAppear {
                    guard !voiceOverEnabled else { return }
                    viewModel.speakInstruction()
                }
                .onDisappear { viewModel.stop() }
        }
    }


    private var content: some View {
        VStack {
            instruction

            letterZone

            fruits

            bottomRow
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 8)
        .fontDesign(.rounded)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .coordinateSpace(.named(FruitTile.coordinateSpace))
    }

    private var instruction: some View {
        Button(viewModel.title, systemImage: "speaker.wave.2.fill") {
            viewModel.speakInstruction()
        }
        .font(.largeTitle.bold())
        .lineLimit(1)
        .minimumScaleFactor(0.6)
        .buttonStyle(.glass)
        .controlSize(.extraLarge)
    }

    private var letterZone: some View {
        VStack(spacing: 12) {
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

            Text("\(viewModel.letter) is for \(viewModel.game.target.name)! \(viewModel.game.target.emoji)")
                .font(.title.bold())
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .glassEffect(.regular, in: .capsule)
                .opacity(viewModel.isSolved ? 1 : 0)
                .accessibilityHidden(!viewModel.isSolved)
                .animation(.default, value: viewModel.isSolved)
        }
    }

    // The letter turns green when a fruit is over it and when the game is solved
    private var zoneTint: Color {
        viewModel.isSolved || viewModel.isHoveringLetter ? .green.opacity(0.5) : .orange.opacity(0.3)
    }

    private var fruits: some View {
        HStack(spacing: 36) {
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
    FruitDragView(game: FruitDragGameModel.all[0], onCorrect: {})
}
