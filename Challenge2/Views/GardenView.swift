//
//  GardenView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 19/11/2026.
//

import SwiftUI

struct GardenView: View {

    @State private var viewModel: GardenViewModel
    @Environment(\.screenSize) private var screen
    // Tapping the mascot here talks about the plant, not about a game.
    @State private var coach = MascotCoach(mascot: Mascot.happy.saying([
        "Water your plant to help it grow!",
        "Every drop helps your flower bloom!",
        "Play games to win more water drops!",
        "Look how much it has grown!",
    ]))

    init(
        waterDrops: Int, plantDrops: Int, unlockedFlowers: [String],
        onChange: @escaping (Int, Int) -> Void,
        onFlowerCompleted: @escaping () -> [String]
    ) {
        _viewModel = State(initialValue: GardenViewModel(
            availableDrops: waterDrops, plantDrops: plantDrops, unlockedFlowers: unlockedFlowers,
            onChange: onChange, onFlowerCompleted: onFlowerCompleted))
    }

    private var title: some View {
        Text("My Garden")
            .font(.system(size: screen.value(regular: 50, portrait: 34, landscape: 26), weight: .bold, design: .rounded))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .padding(.horizontal, screen.isCompact ? 20 : 32)
            .padding(.vertical, screen.isCompact ? 6 : 12)
            .glassEffect(.regular, in: .capsule)
    }

    // The mascot floats over the bottom-left corner. iPad has an empty corner for it;
    // on iPhone the layout leaves room for it instead.
    private var content: some View {
        VStack(spacing: screen.isCompact ? 12 : 16) {
            if screen.isPhoneLandscape {
                // Title and stages share one row: height is the scarce thing here.
                HStack(spacing: 16) {
                    title
                    stageBar
                }
            } else {
                title
                Spacer()
                stageBar
                Spacer()
            }

            if screen.isPhonePortrait {
                plant
                sign
                Color.clear.frame(height: screen.mascotHeight)
            } else {
                HStack(alignment: .bottom) {
                    Color.clear.frame(width: screen.isPhoneLandscape ? screen.mascotHeight : 250, height: 1)

                    Spacer()

                    plant

                    Spacer()

                    sign
                }
                .padding(.horizontal, screen.isCompact ? 0 : 20)
            }
        }
        .padding(screen.isCompact ? 12 : 16)
    }

    var body: some View {
            ScrollIfNeeded { content }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            .mascotOverlay(coach, mascot: viewModel.mascot)
            .task {
                // Say what matters right now; a happy plant needs no extra words.
                if viewModel.stage == .flower {
                    coach.say("Your flower bloomed! Plant a new seed!")
                } else if viewModel.availableDrops == 0 {
                    coach.say("No drops left! Play games to win more!")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 8) {
                        Image(systemName: "drop.fill")
                            .foregroundStyle(.blue)

                        Text("\(viewModel.availableDrops)")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .bold,
                                    design: .rounded))
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(viewModel.availableDrops) water drops")
                }
            }
    }

    
    // Four stages of 100 pt don't fit across a phone, so they shrink with the screen.
    private var stageSize: CGFloat { screen.value(regular: 100, portrait: 64, landscape: 44) }

    private var stageBar: some View {
        GlassEffectContainer(spacing: 15) {
            HStack(spacing: screen.isCompact ? 10 : 15) {
                ForEach(PlantStage.allCases, id: \.self) { stage in
                    
                    let reached = stage.rawValue <= viewModel.stage.rawValue
                    
                    Image(stage.image)
                        .resizable()
                        .scaledToFit()
                        .saturation(reached ? 1 : 0)
                        .opacity(reached ? 1 : 0.45)
                        .padding(screen.isCompact ? 8 : 14)
                        .frame(width: stageSize, height: stageSize)
                        .glassEffect(.regular, in: .circle)
                        .overlay {
                            Circle()
                                .stroke(
                                    .green,
                                    lineWidth: stage == viewModel.stage ? 5 : 0
                                )
                        }
                        .accessibilityLabel(stage.image)
                        .accessibilityAddTraits(
                            stage == viewModel.stage ? .isSelected : []
                        )
                }
            }
            .animation(
                .spring(response: 0.4, dampingFraction: 0.75),
                value: viewModel.stage
            )
        }
    }

    var plant: some View {
        VStack(spacing: 15) {

            Image(viewModel.plantImage)
                .resizable()
                .scaledToFit()
                .frame(height: screen.value(regular: 300, portrait: 220, landscape: 110))

                .id(viewModel.stage)
                .transition(
                    .scale.combined(with: .opacity)
                )

            if viewModel.stage == .flower {

                Button("New Seed") {
                    withAnimation(.spring()) {
                        viewModel.restart()
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

            } else {

                Button {
                    withAnimation(.spring(response: 0.45)) {
                        viewModel.water()
                    }

                } label: {
                    Label(
                        "Water",
                        systemImage: "drop.fill"
                    )
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.extraLarge)

                .disabled(viewModel.availableDrops == 0)
            }
        }
    }

    var sign: some View {

        VStack(spacing: 8) {

            if let next = viewModel.stage.next {

                Text("Next stage:")
                    .font(.system(size: 24, weight: .bold, design: .rounded))

                Image(next.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: screen.isCompact ? 50 : 80)
                    .saturation(0)
                    .opacity(0.6)

                Text("\(viewModel.dropsToNextStage) more drops!")
                    .font(
                        .system(size: 20, weight: .semibold, design: .rounded)
                    )
            } else {
                Text(viewModel.albumComplete ? "You found them all!" : "Full bloom!")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                Text(viewModel.albumComplete
                     ? "Every flower is in your album!"
                     : "You grew a beautiful flower!")
                    .font(.system(size: 18, weight: .medium))
                    .multilineTextAlignment(.center)
            }
        }
        .foregroundStyle(.secondary)
        .padding(screen.isCompact ? 14 : 20)
        .frame(width: screen.value(regular: 240, portrait: 280, landscape: 200))
        .glassEffect(.regular, in:.capsule)
    }
}

#Preview {
    NavigationStack {
        GardenView(waterDrops: 5, plantDrops: 0, unlockedFlowers: [], onChange: { _, _ in }, onFlowerCompleted: { ["flower_daisy"] })
    }
}
