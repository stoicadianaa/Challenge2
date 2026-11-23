import SwiftUI

struct FlowerCardView: View {
    let flower: Flower

    var body: some View {
        Color.clear
           .aspectRatio(4 / 3, contentMode: .fit)
            .overlay {
                flowerContent
                    .padding(8)
            }
            .overlay(alignment: .bottomTrailing) {
                if !flower.isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .frame(width: 40, height: 40)
                        .glassEffect(.regular, in: .circle)
                        .padding(10)
                }
            }
            .glassEffect(
                flower.isUnlocked ? .regular.tint(.green.opacity(0.12)) : .regular,
                  in: .rect(cornerRadius: 26)
            )
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
            Color.secondary
                .opacity(0.35)
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
