import SwiftUI

struct FlowerAlbumView: View {
    @Environment(FlowerAlbumViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    @State private var measuredCardHeight: CGFloat = 180

    private let spacing: CGFloat = 16
    private let sidePadding: CGFloat = 32

    // Minimum number of album spaces: 6 rows of 5.
    private let albumCapacity = 30

    private let upcomingFlowerAssets = [
        "flower_bluebell",
        "flower_forgetmenot",
        "flower_sakura",
        "flower_mint_lotus",
        "flower_apricot_hibiscus",
        "flower_wildrose",
        "flower_poppy",
        "flower_tulip",
        "flower_daisy",
        "flower_sunflower",
        "flower_lilac_cosmos",
        "flower_pink_blossom",
        "flower_buttercup"
    ]

    private var extraSlotCount: Int {
        max(0, albumCapacity - viewModel.flowers.count)
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(
                .flexible(minimum: 0),
                spacing: spacing
            ),
            count: 5
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            albumHeader

            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: spacing) {

                    // Original cards: no extra background or shadow.
                    ForEach(viewModel.flowers) { flower in
                        FlowerCardView(flower: flower)
                            .onGeometryChange(for: CGFloat.self) { geometry in
                                geometry.size.height
                            } action: { height in
                                if height > 0,
                                   abs(measuredCardHeight - height) > 0.5 {
                                    measuredCardHeight = height
                                }
                            }
                    }

                    // Additional locked spaces continue below the screen.
                    ForEach(0..<extraSlotCount, id: \.self) { index in
                        AlbumUpcomingFlowerCard(
                            imageName: upcomingFlowerAssets[
                                index % upcomingFlowerAssets.count
                            ],
                            height: measuredCardHeight
                        )
                    }
                }
                .padding(.horizontal, sidePadding)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.visible)
            .scrollBounceBehavior(.basedOnSize)

            AlbumEncouragementBanner()
                .padding(.horizontal, sidePadding)
                .padding(.top, 14)
                .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            GeometryReader { background in
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: background.size.width,
                        height: background.size.height
                    )
                    .clipped()
            }
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Title and Back Button

    private var albumHeader: some View {
        ZStack {
            Text("Your Flower Album")
                .font(
                    .system(
                        size: 36,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(
                    Color(red: 0.35, green: 0.24, blue: 0.13)
                )
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding(.horizontal, 68)

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(
                            .system(size: 25, weight: .semibold)
                        )
                        .foregroundStyle(
                            Color(red: 0.28, green: 0.36, blue: 0.12)
                        )
                        .frame(width: 52, height: 52)
                        .background(
                            Color(red: 0.80, green: 0.91, blue: 0.48),
                            in: Circle()
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back")

                Spacer(minLength: 0)
            }
        }
        .frame(height: 64)
        .padding(.horizontal, sidePadding)
        .padding(.top, 4)
        .padding(.bottom, 12)
    }
}

// MARK: - Additional Locked Spaces

private struct AlbumUpcomingFlowerCard: View {
    let imageName: String
    let height: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {

                // A single white card.
                RoundedRectangle(
                    cornerRadius: 24,
                    style: .continuous
                )
                .fill(.white)

                Image(imageName)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(
                        Color(red: 0.89, green: 0.84, blue: 0.80)
                    )
                    .frame(
                        width: geometry.size.width * 0.48,
                        height: geometry.size.height * 0.62
                    )
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )

                Image(systemName: "lock.fill")
                    .font(
                        .system(size: 20, weight: .semibold)
                    )
                    .foregroundStyle(
                        Color(red: 0.75, green: 0.61, blue: 0.51)
                    )
                    .padding(16)
            }
        }
        .frame(height: height)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            "Flower locked. Play more games to unlock flowers."
        )
    }
}

// MARK: - Bottom Message

private struct AlbumEncouragementBanner: View {
    var body: some View {
        HStack(spacing: 18) {
            Image("flower_buttercup")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 62)
                .accessibilityHidden(true)

            Text("Play more games to unlock new flowers!")
                .font(
                    .system(
                        size: 25,
                        weight: .semibold,
                        design: .rounded
                    )
                )
                .foregroundStyle(
                    Color(red: 0.43, green: 0.29, blue: 0.17)
                )
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 12)
        .frame(maxWidth: 740)
        .background(
            .white,
            in: RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
        )
        .shadow(
            color: .brown.opacity(0.12),
            radius: 3,
            y: 3
        )
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        FlowerAlbumView()
    }
    .environment(FlowerAlbumViewModel())
}
