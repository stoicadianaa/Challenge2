import SwiftUI

struct FlowerCardView: View {
    let flower: Flower

    var body: some View {
        RoundedRectangle(cornerRadius: 26)
            .fill(Color(.systemBackground))
            .shadow(color: .brown.opacity(0.16), radius: 3, y: 4)
            .aspectRatio(4 / 3, contentMode: .fit)
            .overlay {
                flowerContent
                    .padding(20)
            }
            .overlay(alignment: .bottomTrailing) {
                if !flower.isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.title.bold())
                        .foregroundStyle(.brown.opacity(0.75))
                        .padding(14)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(
                flower.isUnlocked ? "\(flower.name), unlocked" : "Locked flower"
            )
    }

    private var flowerImage: some View {
        Image(flower.imageName)
            .resizable()
            .scaledToFit()
    }

    // Locked flowers show only their shape, without revealing the details.
    @ViewBuilder
    private var flowerContent: some View {
        if flower.isUnlocked {
            flowerImage
        } else {
            Color.brown
                .opacity(0.3)
                .mask { flowerImage }
        }
    }
}

#Preview {
    HStack {
        FlowerCardView(
            flower: Flower(imageName: "flower_daisy", name: "Daisy", isUnlocked: true)
        )
        FlowerCardView(
            flower: Flower(imageName: "flower_tulip", name: "Tulip", isUnlocked: false)
        )
    }
    .padding()
}
