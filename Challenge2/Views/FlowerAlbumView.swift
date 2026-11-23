import SwiftUI

struct FlowerAlbumView: View {
    // imageName of the flowers the child has unlocked.
    let unlockedFlowers: [String]

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
        .overlay(alignment: .bottomTrailing) {
            VStack(alignment: .trailing, spacing: -6) {
                AlbumSpeechBubble(
                    text: isComplete
                        ? "You found all the flowers!"
                        : "Play more games to unlock new flowers!")
                
                Image(isComplete ? "mascot_genderless_celebrating" : "mascot_genderless_happy")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 170)
            }
            .padding(.trailing, 24)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
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

private struct TailBubbleShape: Shape {
    var cornerRadius: CGFloat = 28
    var tailSize: CGFloat = 20
    var tailInset: CGFloat = 70

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let body = CGRect(x: rect.minX, y: rect.minY,
                          width: rect.width, height: rect.height - tailSize)
        path.addRoundedRect(in: body,
                            cornerSize: CGSize(width: cornerRadius, height: cornerRadius),
                            style: .continuous)

        let tipX = rect.maxX - tailInset
        var tail = Path()
        tail.move(to: CGPoint(x: tipX - tailSize, y: body.maxY - 1))
        tail.addLine(to: CGPoint(x: tipX + tailSize * 0.2, y: rect.maxY))
        tail.addLine(to: CGPoint(x: tipX + tailSize, y: body.maxY - 1))
        tail.closeSubpath()

        path.addPath(tail)
        return path
    }
}

private struct AlbumSpeechBubble: View {
    let text: String
    private let tailSize: CGFloat = 20

    var body: some View {
        Text(text)
            .font(.system(.title3, design: .rounded, weight: .semibold))
            .foregroundStyle(.primary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
            .padding(.top, 14)
            .padding(.bottom, 14 + tailSize) 
            .frame(maxWidth: 300)
            .glassEffect(.regular, in: TailBubbleShape(tailSize: tailSize))
    }
}

#Preview {
    NavigationStack {
        FlowerAlbumView(unlockedFlowers: ["flower_daisy", "flower_poppy"])
    }
}
