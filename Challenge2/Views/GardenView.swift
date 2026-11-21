//
//  GardenView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 19/11/2026.
//

import SwiftUI

struct GardenView: View {

    @State private var viewModel = GardenViewModel()

    var body: some View {
            VStack(spacing: 16) {

                VStack(spacing: 4) {
                    Text("My Garden")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .glassEffect(.regular, in: .capsule)
                }

                Spacer()

                stageBar

                Spacer()

                HStack(alignment: .bottom) {
                    Image(viewModel.mascotImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)
                        .accessibilityHidden(true)

                    Spacer()

                    plant

                    Spacer()

                    sign
                }
                .padding(.horizontal, 20)
            }
            .padding()
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
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

    
    private var stageBar: some View {
        GlassEffectContainer(spacing: 15) {
            HStack(spacing: 15) {
                ForEach(PlantStage.allCases, id: \.self) { stage in
                    
                    let reached = stage.rawValue <= viewModel.stage.rawValue
                    
                    Image(stage.image)
                        .resizable()
                        .scaledToFit()
                        .saturation(reached ? 1 : 0)
                        .opacity(reached ? 1 : 0.45)
                        .padding(14)
                        .frame(width: 84, height: 84)
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
                .frame(height: 300)

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
                    .frame(height: 60)
                    .saturation(0)
                    .opacity(0.6)

                Text("\(viewModel.dropsToNextStage) more drops!")
                    .font(
                        .system(size: 20, weight: .semibold, design: .rounded)
                    )
            } else {
                Text("Full bloom!")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                Text("You grew a beautiful flower!")
                    .font(.system(size: 18, weight: .medium))
                    .multilineTextAlignment(.center)
            }
        }
        .foregroundStyle(.brown)
        .padding(20)
        .frame(width: 240)
        .background(
            Color(red: 0.98, green: 0.88, blue: 0.66),
            in: RoundedRectangle(cornerRadius: 20)
        )
    }
}

#Preview {
    NavigationStack {
        GardenView()
    }
}
