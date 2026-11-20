//
//  OrderingGame.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 18/11/2026.
//

import SwiftUI 

struct OrderingGame: View {
    @State var game: OrderingGameModel
    @State private var checkResult: Bool? = nil

    // Called when the order is correct. The session decides what happens next.
    let onCorrect: () -> Void

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

            HStack(spacing: 32) {
                ForEach(game.elements) { element in
                    Text(element.emoji)
                        .padding()
                        .glassEffect(.regular, in: .rect(cornerRadius: 32))
                }
                .reorderable()
            }
            .frame(maxWidth: .infinity)
            .font(.system(size: 180))
            .reorderContainer(for: OrderingGameItem.self) { difference in
                game.apply(difference)
                checkResult = nil
            }

            Spacer()

            Button("Check") {
                checkResult = game.isInCorrectOrder
            }
            .buttonStyle(.glassProminent)
            .tint(.green)
            .controlSize(.extraLarge)
            .font(.title.bold())

            if let result = checkResult {
                Text(result ? "Correct! 🎉" : "Try again")
            }

            Spacer()

        }
        .fontDesign(.rounded)
        .background {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .onAppear {
            game.shuffle()
        }
        // On a correct answer, wait 1.5s so the child sees "Correct!", then continue.
        // Unlike a plain Task, .task is cancelled if the view goes away, so a game
        // the child left can't still finish and award drops.
        .task(id: checkResult) {
            guard checkResult == true else { return }
            try? await Task.sleep(for: .seconds(1.5))
            guard !Task.isCancelled else { return }
            onCorrect()
        }
    }
}

#Preview {
    let game = GameViewModel().games(type: .ordering, difficulty: .easy).first!
    if case .ordering(let model) = game.content {
        OrderingGame(game: model, onCorrect: {})
    }
}
