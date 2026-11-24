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

    @Environment(\.screenSize) private var screen

    private var tileSpacing: CGFloat { screen.isCompact ? 8 : 20 }
    private var tilePadding: CGFloat { screen.isCompact ? 8 : 20 }

    // As big as the row allows: few items get huge emoji, 5-6 shrink so the row still fits.
    // Both the width and the height of the row limit it, so landscape phones don't overflow.
    private func emojiSize(row: CGSize) -> CGFloat {
        let count = CGFloat(game.elements.count)
        let tileWidth = (row.width - tileSpacing * (count - 1)) / count
        let byWidth = (tileWidth - tilePadding * 2) / 1.25
        let byHeight = (row.height - tilePadding * 2) / 1.25
        return max(24, min(240, byWidth, byHeight))
    }

    var body: some View {
        GameScreen(title: game.title, coach: coach) {
            GeometryReader { row in
                HStack(spacing: tileSpacing) {
                    ForEach(game.elements) { element in
                        Text(element.emoji)
                            .padding(tilePadding)
                            .glassEffect(.regular, in: .rect(cornerRadius: screen.isCompact ? 20 : 36))
                    }
                    .reorderable()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.system(size: emojiSize(row: row.size)))
                .reorderContainer(for: OrderingGameItem.self) { difference in
                    game.apply(difference)
                    showTryAgain = false
                }
            }
            .frame(height: screen.value(regular: 340, portrait: 160, landscape: 140))
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
