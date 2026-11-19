import SwiftUI

struct FlowerAlbumView: View {
    @Environment(FlowerAlbumViewModel.self) private var viewModel

    private let columns = [GridItem(.adaptive(minimum: 240), spacing: 16)]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.flowers) { flower in
                        FlowerCardView(flower: flower)
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
