import SwiftUI

struct FlowerAlbumView: View {
    @Environment(\.dismiss) private var dismiss

    // Sample progress
    private let unlockedCount = 5

    private let flowers = [
        "flower_daisy",
        "flower_tulip",
        "flower_sunflower",
        "flower_lilac_cosmos",
        "flower_poppy",
        "flower_bluebell",
        "flower_buttercup",
        "flower_sakura"
    ]

    private let brown = Color(
        red: 0.36,
        green: 0.25,
        blue: 0.13
    )

    private let cream = Color(
        red: 1.0,
        green: 0.95,
        blue: 0.83
    )

    private let silhouetteColor = Color(
        red: 0.76,
        green: 0.69,
        blue: 0.56
    )

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 16),
        count: 4
    )

    var body: some View {
        GeometryReader { geometry in
            let contentWidth = min(
                max(geometry.size.width - 48, 0),
                1000
            )

            let cardHeight = min(
                220,
                max(110, (geometry.size.height - 260) / 2)
            )

            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .clipped()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        header

                        LazyVGrid(
                            columns: columns,
                            spacing: 16
                        ) {
                            ForEach(flowers.indices, id: \.self) { index in
                                flowerCard(
                                    at: index,
                                    height: cardHeight
                                )
                            }
                        }

                        encouragementMessage
                    }
                    .frame(width: contentWidth)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                }
                .scrollIndicators(.hidden)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Header

    private var header: some View {
        Text("Your Flower Album")
            .font(.system(
                size: 32,
                weight: .bold,
                design: .rounded
            ))
            .foregroundStyle(brown)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 72)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 60)
            .overlay(alignment: .leading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(
                            size: 25,
                            weight: .bold
                        ))
                        .foregroundStyle(brown)
                        .frame(width: 56, height: 56)
                        .background(cream, in: Circle())
                        .shadow(
                            color: brown.opacity(0.15),
                            radius: 3,
                            y: 3
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back")
            }
    }

    // MARK: - Flower Card

    private func flowerCard(
        at index: Int,
        height: CGFloat
    ) -> some View {
        let isUnlocked = index < unlockedCount

        return ZStack {
            RoundedRectangle(cornerRadius: 26)
                .fill(cream)
                .shadow(
                    color: brown.opacity(0.16),
                    radius: 3,
                    y: 4
                )

            if isUnlocked {
                Image(flowers[index])
                    .resizable()
                    .scaledToFit()
                    .padding(20)
            } else {
                // Use each flower's shape without revealing its details.
                silhouetteColor
                    .mask {
                        Image(flowers[index])
                            .resizable()
                            .scaledToFit()
                            .padding(20)
                    }
                    .opacity(0.55)
            }
        }
        .frame(height: height)
        .overlay(alignment: .bottomTrailing) {
            if !isUnlocked {
                Image(systemName: "lock.fill")
                    .font(.system(
                        size: 24,
                        weight: .bold
                    ))
                    .foregroundStyle(brown.opacity(0.75))
                    .padding(14)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            isUnlocked
                ? "Flower \(index + 1), unlocked"
                : "Flower \(index + 1), locked"
        )
    }

    // MARK: - Bottom Message

    private var encouragementMessage: some View {
        HStack(spacing: 16) {
            Image("flower_buttercup")
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 64)
                .accessibilityHidden(true)

            Text("Play more games to unlock new flowers!")
                .font(.system(
                    size: 22,
                    weight: .semibold,
                    design: .rounded
                ))
                .foregroundStyle(brown)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 14)
        .frame(maxWidth: 580)
        .background(
            cream,
            in: RoundedRectangle(cornerRadius: 28)
        )
        .shadow(
            color: brown.opacity(0.12),
            radius: 3,
            y: 3
        )
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    FlowerAlbumView()
}

