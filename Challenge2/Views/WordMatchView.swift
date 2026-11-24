//
//  WordMatchView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//
import SwiftUI

struct WordMatchView: View {

    @State private var viewModel: WordMatchViewModel
    @Environment(\.screenSize) private var screen

    // Called when the child finds the word. The session decides what happens next.
    let onCorrect: (GameResult) -> Void

    init(question: WordMatchQuestion, onCorrect: @escaping (GameResult) -> Void) {
        _viewModel = State(initialValue: WordMatchViewModel(question: question))
        self.onCorrect = onCorrect
    }

    var body: some View {
        GameScreen(title: "Find the correct word!", coach: viewModel.coach) {
            // The picture and its answers stay together, so they read as one question.
            VStack(spacing: screen.isCompact ? 16 : 32) {
                emojiCard
                choices
            }
        } footer: {
            EmptyView()
        }
        // After a correct answer, let the mascot finish talking, then hand over to the session.
        // The task is cancelled automatically if the screen closes first.
        .task(id: viewModel.selectedAnswer) {
            guard viewModel.isAnswered else { return }
            await viewModel.coach.waitUntilQuiet()
            try? await Task.sleep(for: .seconds(0.5))  // a beat to enjoy the praise
            guard !Task.isCancelled else { return }
            onCorrect(GameResult(solvedFirstTry: viewModel.wrongAnswers.isEmpty))
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

    private var emojiCard: some View {
        Text(viewModel.question.emoji)
            .font(.system(size: screen.value(regular: 180, portrait: 110, landscape: 80)))
            .padding(.horizontal, screen.isCompact ? 32 : 64)
            .padding(.vertical, screen.isCompact ? 14 : 28)
            .glassEffect(.regular, in: .rect(cornerRadius: screen.isCompact ? 32 : 48))
    }

    // Stacked on a phone held upright, so each word keeps a big, readable button
    // instead of three squeezed ones.
    private var choicesLayout: AnyLayout {
        screen.isPhonePortrait
            ? AnyLayout(VStackLayout(spacing: 12))
            : AnyLayout(HStackLayout(spacing: screen.isCompact ? 12 : 24))
    }

    private var choices: some View {
        choicesLayout {
            ForEach(
                Array(viewModel.question.choices.enumerated()),
                id: \.element
            ) { index, choice in
                Button {
                    viewModel.choose(choice)
                } label: {
                    Text(choice)
                        .font(
                            .system(.title, design: .rounded, weight: .heavy)
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .frame(maxWidth: .infinity)
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
}

#Preview {
    WordMatchView(question: WordMatchQuestion.all[0], onCorrect: { _ in })
}
