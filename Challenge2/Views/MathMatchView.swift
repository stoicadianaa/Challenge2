//
//  MathMatchView.swift
//  Challenge2
//
//  Same layout as Word Match: a picture or sum in a card, numbers to choose from below.
//

import SwiftUI

struct MathMatchView: View {

    @State private var viewModel: MathMatchViewModel
    @Environment(\.screenSize) private var screen

    // Called when the child finds the number. The session decides what happens next.
    let onCorrect: (GameResult) -> Void

    init(question: MathQuestion, onCorrect: @escaping (GameResult) -> Void) {
        _viewModel = State(initialValue: MathMatchViewModel(question: question))
        self.onCorrect = onCorrect
    }

    var body: some View {
        GameScreen(title: viewModel.question.title, coach: viewModel.coach) {
            VStack(spacing: screen.isCompact ? 16 : 32) {
                promptCard
                choices
            }
        } footer: {
            EmptyView()
        }
        // After a correct answer, let the mascot finish talking, then hand over to the session.
        .task(id: viewModel.selectedAnswer) {
            guard viewModel.isAnswered else { return }
            await viewModel.coach.waitUntilQuiet()
            try? await Task.sleep(for: .seconds(0.5))  // a beat to enjoy the praise
            guard !Task.isCancelled else { return }
            onCorrect(GameResult(solvedFirstTry: viewModel.wrongAnswers.isEmpty))
        }
        .sensoryFeedback(.success, trigger: viewModel.selectedAnswer) { _, new in new != nil }
        .sensoryFeedback(.error, trigger: viewModel.wrongAnswers.count) { old, new in new > old }
    }

    // Emoji for counting, digits for sums: both shrink instead of overflowing.
    private var promptCard: some View {
        Text(viewModel.question.prompt)
            .font(.system(size: screen.value(regular: 140, portrait: 90, landscape: 64), weight: .heavy, design: .rounded))
            .lineLimit(1)
            .minimumScaleFactor(0.4)
            .padding(.horizontal, screen.isCompact ? 32 : 64)
            .padding(.vertical, screen.isCompact ? 14 : 28)
            .glassEffect(.regular, in: .rect(cornerRadius: screen.isCompact ? 32 : 48))
            .accessibilityLabel(viewModel.question.title)
    }

    // Stacked on a phone held upright, so each number keeps a big button.
    private var choicesLayout: AnyLayout {
        screen.isPhonePortrait
            ? AnyLayout(VStackLayout(spacing: 12))
            : AnyLayout(HStackLayout(spacing: screen.isCompact ? 12 : 24))
    }

    private var choices: some View {
        choicesLayout {
            ForEach(Array(viewModel.choices.enumerated()), id: \.element) { index, choice in
                Button {
                    viewModel.choose(choice)
                } label: {
                    Text("\(choice)")
                        .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
                .tint(tint(for: choice, at: index))
                .controlSize(.extraLarge)
                .disabled(viewModel.wrongAnswers.contains(choice))  // a wrong number can't be tapped again
                .allowsHitTesting(!viewModel.isAnswered)            // once found, the others are locked
            }
        }
    }

    private func tint(for choice: Int, at index: Int) -> Color {
        if choice == viewModel.selectedAnswer { return .green }
        if viewModel.wrongAnswers.contains(choice) { return .red }
        return [Color.blue, .teal, .orange][index % 3]
    }
}

#Preview {
    MathMatchView(question: MathQuestion.all[0], onCorrect: { _ in })
}
