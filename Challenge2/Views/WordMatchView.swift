//
//  WordMatchView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//
import SwiftUI

struct WordMatchView: View {

    @State private var viewModel: WordMatchViewModel

    // onReward is called once, at the end of the game
    init(onReward: @escaping (Int) -> Void = { _ in }) {
        _viewModel = State(initialValue: WordMatchViewModel(onReward: onReward))
    }

    var body: some View {
        VStack(spacing: 20) {
            instruction
            emojiCard
            choices
            feedback

            HStack(spacing: 24) {
                Image("mascot_genderless_neutral")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 160)
                    .accessibilityHidden(true)
                    
                nextButton
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .accessibilityHidden(true)
        }
        .navigationTitle("Word Match")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Label("\(viewModel.score) / \(viewModel.questions.count)", systemImage: "star.fill")
                    .foregroundStyle(.primary)
                    .accessibilityLabel("Score: \(viewModel.score) of \(viewModel.questions.count)")
            }
        }
        .sensoryFeedback(.success, trigger: viewModel.selectedAnswer) { _, new in new != nil }
        .sensoryFeedback(.error, trigger: viewModel.wrongAnswers.count) { old, new in new > old }
        .fullScreenCover(isPresented: $viewModel.showReward, onDismiss: viewModel.restart) {
            RewardScreen()
        }
    }
    
    private var instruction: some View {
        VStack(spacing: 12) {
            Button("Find the correct word!", systemImage: "speaker.wave.2.fill") {
                viewModel.speak("Find the correct word!")
            }
            .font(.system(.title2, design: .rounded, weight: .bold))
            .buttonStyle(.glass)
            .controlSize(.extraLarge)

            ProgressView(value: viewModel.progress)
                .tint(.green)
                .frame(width: 300)
                .accessibilityLabel("Progress")
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
            ForEach(Array(viewModel.question.choices.enumerated()), id: \.element) { index, choice in
                Button {
                    viewModel.choose(choice)
                } label: {
                    Text(choice)
                        .font(.system(.title2, design: .rounded, weight: .heavy))
                        .frame(minWidth: 150)
                }
                .buttonStyle(.glassProminent)
                .tint(tint(for: choice, at: index))
                .controlSize(.extraLarge)
                .disabled(viewModel.wrongAnswers.contains(choice))   // a wrong word can't be tapped again
                .allowsHitTesting(!viewModel.isAnswered)             // once found, the others are locked
            }
        }
    }

    private func tint(for choice: String, at index: Int) -> Color {
        if choice == viewModel.selectedAnswer { return .green }
        if viewModel.wrongAnswers.contains(choice) { return .red }
        return [Color.blue, .teal, .orange][index % 3]
    }


    private var feedback: some View {
        Text(viewModel.feedback)
            .font(.system(.title3, design: .rounded, weight: .bold))
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .glassEffect(.regular, in: .capsule)
            .animation(.default, value: viewModel.feedback)
    }

    private var nextButton: some View {
        Button(viewModel.isLastQuestion ? "Finish" : "Next", systemImage: "arrow.right") {
            viewModel.next()
        }
        .buttonStyle(.glassProminent)
        .tint(.green)
        .controlSize(.extraLarge)
        .opacity(viewModel.isAnswered ? 1 : 0)
        .disabled(!viewModel.isAnswered)
        .accessibilityHidden(!viewModel.isAnswered)
        .animation(.default, value: viewModel.isAnswered)
    }
}

#Preview() {
    WordMatchView()
}
