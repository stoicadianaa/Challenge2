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

    @Environment(\.screenSize) private var screen

    // 4 cards per row, but only 2 on a phone held upright, where 4 would be too small to see.
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 16), count: screen.isPhonePortrait ? 2 : 4)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(flowers) { flower in
                        FlowerCardView(flower: flower)
                    }
                }
            }
            .padding(screen.isCompact ? 16 : 32)
            // Keeps the last row clear of the floating mascot.
            .padding(.bottom, screen.value(regular: 260, portrait: screen.mascotHeight + 40, landscape: screen.mascotHeight + 20))
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
                    .font(.system(size: screen.value(regular: 36, portrait: 22, landscape: 26), weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .padding(.horizontal, screen.isCompact ? 14 : 24)
                    .padding(.vertical, screen.isCompact ? 6 : 8)
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
