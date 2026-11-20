import SwiftUI

struct FlowerAlbumView: View {
    @Environment(FlowerAlbumViewModel.self) private var viewModel

    // Always 5 cards per row, so the cards are smaller than with an adaptive grid.
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 5)

    // TEMPORARY: only for previewing how the screen looks when it is filled.
    // Remove once the view model has enough real flowers.
    private let placeholderTotal = 30

    private var placeholderCount: Int {
        guard !viewModel.flowers.isEmpty else { return 0 }
        return max(0, placeholderTotal - viewModel.flowers.count)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.flowers) { flower in
                        FlowerCardView(flower: flower)
                    }

                    // TEMPORARY: extra locked cards, just to see how the screen looks filled.
                    // They reuse the real flowers' images and are not part of the data.
                    ForEach(0..<placeholderCount, id: \.self) { index in
                        let source = viewModel.flowers[index % viewModel.flowers.count]
                        FlowerCardView(
                            flower: Flower(
                                imageName: source.imageName,
                                name: "Placeholder",
                                isUnlocked: false
                            )
                        )
                    }
                }
            }
            .padding(32)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom, content: {
            EncouragementBanner()
        })
        .background {
            Color.clear
                .overlay {
                    Image("background")
                        .resizable()
                        .scaledToFill()
                }
                .clipped()
                .ignoresSafeArea()
        }
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle("Your Flower Album")
        // Larger brown title. The system back button stays, since we use the NavigationStack.
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Your Flower Album")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.35, green: 0.24, blue: 0.13))
            }
        }
    }
}

// MARK: - Bottom Message

private struct EncouragementBanner: View {
    var body: some View {
        HStack(spacing: 16) {
            Image("flower_buttercup")
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 64)
                .accessibilityHidden(true)

            Text("Play more games to unlock new flowers!")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundStyle(.brown)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 14)
        .background(
            Color(.systemBackground),
            in: RoundedRectangle(cornerRadius: 28)
        )
        .shadow(color: .brown.opacity(0.12), radius: 3, y: 3)
        .frame(maxWidth: 580)
    }
}

#Preview {
    NavigationStack {
        FlowerAlbumView()
    }
    .environment(FlowerAlbumViewModel())
}
