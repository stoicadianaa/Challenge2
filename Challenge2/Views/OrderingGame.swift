//
//  OrderingGame.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 18/11/2026.
//

import SwiftUI 

struct OrderingGame: View {
    @State var game: OrderingGameModel
    @State private var showTryAgain = false
    @State private var wrongChecks = 0
    @State private var solved = false
    @State private var coach = MascotCoach()

    // Called when the order is correct. The session decides what happens next.
    let onCorrect: (GameResult) -> Void

    private let tileSpacing: CGFloat = 20
    private let tilePadding: CGFloat = 20

    // As big as the row allows: few items get huge emoji, 5-6 shrink so the row still fits.
    private func emojiSize(rowWidth: CGFloat) -> CGFloat {
        let count = CGFloat(game.elements.count)
        let tileWidth = (rowWidth - tileSpacing * (count - 1)) / count
        return min(240, (tileWidth - tilePadding * 2) / 1.25)
    }

    var body: some View {
        GameScreen(title: game.title, coach: coach) {
            GeometryReader { row in
                HStack(spacing: tileSpacing) {
                    ForEach(game.elements) { element in
                        Text(element.emoji)
                            .padding(tilePadding)
                            .glassEffect(.regular, in: .rect(cornerRadius: 36))
                    }
                    .reorderable()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.system(size: emojiSize(rowWidth: row.size.width)))
                .reorderContainer(for: OrderingGameItem.self) { difference in
                    game.apply(difference)
                    showTryAgain = false
                }
            }
            .frame(height: 340)
        } footer: {
            VStack(spacing: 12) {
                Button("Check") {
                    if game.isInCorrectOrder {
                        // Right answer: the mascot praises, then the task below hands over to the session.
                        solved = true
                        coach.say("Amazing! Well done!")
                    } else {
                        wrongChecks += 1
                        showTryAgain = true
                        coach.say("Try again! You can do it!")
                    }
                }
                .buttonStyle(.glassProminent)
                .tint(.green)
                .controlSize(.extraLarge)
                .disabled(solved)
                .font(.title.bold())

                if showTryAgain {
                    Text("Try again")
                }
            }
        }
        .task(id: solved) {
            guard solved else { return }
            await coach.waitUntilQuiet()
            try? await Task.sleep(for: .seconds(0.5))  // a beat to enjoy the praise
            guard !Task.isCancelled else { return }
            onCorrect(GameResult(solvedFirstTry: wrongChecks == 0))
        }
        .onAppear {
            game.shuffle()
        }
    }
}

#Preview {
    let game = GameViewModel().games(type: .logic, difficulty: .easy).first!
    if case .ordering(let model) = game.content {
        OrderingGame(game: model, onCorrect: { _ in })
    }
}
