import SwiftUI

struct FlowerAlbumView: View {
    // imageName of the flowers the child has unlocked.
    let unlockedFlowers: [String]

    // Tapping the mascot here talks about flowers, not about a game.
    @State private var coach = MascotCoach(mascot: Mascot.happy.saying([
        "Look how pretty they are!",
        "Which flower is your favorite?",
        "Keep playing to find more flowers!",
        "Every flower grows from a little seed!",
    ]))

    private var isComplete: Bool { unlockedFlowers.count >= Flower.catalog.count }

    private var flowers: [Flower] { Flower.album(unlocked: unlockedFlowers) }

    // Always 4 cards per row, so the cards are smaller than with an adaptive grid.
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(flowers) { flower in
                        FlowerCardView(flower: flower)
                    }
                }
            }
            .padding(32)
            .padding(.bottom, 260)
        }
        .scrollIndicators(.hidden)
        .background {
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .accessibilityHidden(true)
        }
        .mascotOverlay(coach, mascot: isComplete ? .celebrating : .happy)
        .task {
            coach.say(isComplete
                ? "You found all the flowers!"
                : "Play more games to unlock new flowers!")
        }
        .navigationTitle("My Flower Album")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("My Flower Album")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .glassEffect(.regular, in: .capsule)
                    .accessibilityAddTraits(.isHeader)
            }
        }
    }
}

#Preview {
    NavigationStack {
        FlowerAlbumView(unlockedFlowers: ["flower_daisy", "flower_poppy"])
    }
}
