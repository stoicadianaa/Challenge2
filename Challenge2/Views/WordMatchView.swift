//
//  WordMatchView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//
import SwiftUI

struct WordMatchView: View {

    @State private var viewModel: WordMatchViewModel

    // Called when the child finds the word. The session decides what happens next.
    let onCorrect: () -> Void

    init(question: WordMatchQuestion, onCorrect: @escaping () -> Void) {
        _viewModel = State(initialValue: WordMatchViewModel(question: question))
        self.onCorrect = onCorrect
    }

    var body: some View {
        // One centered group with even spacing; the two Spacers share the leftover room
        VStack(spacing: 24) {
            Spacer()

            instruction
            emojiCard
            choices

            Spacer()
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // The mascot floats above the game; its bubble may cover the content
        .overlay(alignment: .bottomLeading) {
            mascot
        }
        .background {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .accessibilityHidden(true)
        }
        // After a correct answer, let the mascot finish talking, then hand over to the session.
        // The task is cancelled automatically if the screen closes first.
        .task(id: viewModel.selectedAnswer) {
            guard viewModel.isAnswered else { return }
            await viewModel.waitUntilMascotIsQuiet()
            try? await Task.sleep(for: .seconds(0.5))  // a beat to enjoy the praise
            guard !Task.isCancelled else { return }
            onCorrect()
        }
        .sensoryFeedback(.success, trigger: viewModel.selectedAnswer) {
            _,
            new in new != nil
        }
        .sensoryFeedback(.error, trigger: viewModel.wrongAnswers.count) {
            old,
            new in new > old
        }
    }

    private var instruction: some View {
        VStack(spacing: 12) {
            Button("Find the correct word!", systemImage: "speaker.wave.2.fill")
            {
                viewModel.speakInstruction()
            }
            .font(.system(.title2, design: .rounded, weight: .bold))
            .buttonStyle(.glass)
            .controlSize(.extraLarge)

//            ProgressView(value: viewModel.progress)
//                .tint(.green)
//                .frame(width: 300)
//                .accessibilityLabel("Progress")
        }
    }

    private var emojiCard: some View {
        Text(viewModel.question.emoji)
            .font(.system(size: 120))
            .padding(.horizontal, 56)
            .padding(.vertical, 28)
            .glassEffect(.regular, in: .rect(cornerRadius: 40))
    }

    private var choices: some View {
        HStack(spacing: 20) {
            ForEach(
                Array(viewModel.question.choices.enumerated()),
                id: \.element
            ) { index, choice in
                Button {
                    viewModel.choose(choice)
                } label: {
                    Text(choice)
                        .font(
                            .system(.title2, design: .rounded, weight: .heavy)
                        )
                        .frame(minWidth: 150)
                }
                .buttonStyle(.glassProminent)
                .tint(tint(for: choice, at: index))
                .controlSize(.extraLarge)
                .disabled(viewModel.wrongAnswers.contains(choice))  // a wrong word can't be tapped again
                .allowsHitTesting(!viewModel.isAnswered)  // once found, the others are locked
            }
        }
    }

    private func tint(for choice: String, at index: Int) -> Color {
        if choice == viewModel.selectedAnswer { return .green }
        if viewModel.wrongAnswers.contains(choice) { return .red }
        return [Color.blue, .teal, .orange][index % 3]
    }

    // The bubble shows exactly while the mascot speaks; the view model decides when
    private var mascot: some View {
        MascotView(mascot: viewModel.mascot, message: viewModel.mascotLine) {
            viewModel.encourage()
        }
    }
}

#Preview {
    WordMatchView(question: WordMatchQuestion.all[0], onCorrect: {})
}
