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

    // 3-4 items keep the big emoji; 5 and 6 shrink so the row still fits the screen.
    private var emojiSize: CGFloat {
        switch game.elements.count {
        case ...4: 180
        case 5: 130
        default: 110
        }
    }

    var body: some View {
        VStack {
            Spacer()

            Button(
                game.title,
                systemImage: "speaker.wave.2.fill",
                action: {
                    // todo play the sound of the instructions
                }
            )
            .font(.largeTitle.bold())

            .buttonStyle(.glass)

            Spacer()

            HStack(spacing: game.elements.count > 4 ? 16 : 32) {
                ForEach(game.elements) { element in
                    Text(element.emoji)
                        .padding()
                        .glassEffect(.regular, in: .rect(cornerRadius: 32))
                }
                .reorderable()
            }
            .frame(maxWidth: .infinity)
            .font(.system(size: emojiSize))
            .reorderContainer(for: OrderingGameItem.self) { difference in
                game.apply(difference)
                showTryAgain = false
            }

            Spacer()

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

            Spacer()

        }
        .fontDesign(.rounded)
        .mascotOverlay(coach)
        .task(id: solved) {
            guard solved else { return }
            await coach.waitUntilQuiet()
            try? await Task.sleep(for: .seconds(0.5))  // a beat to enjoy the praise
            guard !Task.isCancelled else { return }
            onCorrect(GameResult(solvedFirstTry: wrongChecks == 0))
        }
        .background {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
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
