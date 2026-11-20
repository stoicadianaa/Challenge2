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
    }
}

#Preview {
    let game: OrderingGameModel = OrderingGameViewModel().games.first!
    OrderingGame(game: game)
}
