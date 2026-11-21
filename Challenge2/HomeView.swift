//
//  HomeView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 18/11/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var waterDropsCount = 0

    @State private var homeViewModel = HomeViewModel()

    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled

    // VoiceOver already reads the screen, so the spoken welcome would talk over it.
    private func greet(_ action: () -> Void) {
        guard !voiceOverEnabled else { return }
        action()
    }

    // The category being played; nil means we're on the home screen.
    private let viewModel = GameViewModel()
    @State private var selectedType: GameType?

    private func play(_ type: GameType) {
        if !viewModel.games(for: type).isEmpty { selectedType = type }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                Spacer()
                
                VStack(spacing: 4) {
                    Text("Welcome to WonderBloom!")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .glassEffect(.regular, in: .capsule)
                }
                                
                Image("mascot_genderless_happy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)

                
                HStack(spacing: 20) {
                    ForEach(GameType.allCases) { game in
                        CategoryCard(game: game) {
                            // Categories without games do nothing when pressed.
                            play(game)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)
                .background(Color.clear)
                
                Spacer()
            }
            .padding()
            
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )

            // Pushes the session while selectedType is set; going back resets it to nil.
            .navigationDestination(item: $selectedType) { type in
                // Plays 1 game by default; pass `gameCount:` for longer sessions.
                // Each game played earns 1 drop.
                GameSessionView(games: viewModel.games(for: type)) { drops in
                    waterDropsCount += drops
                }
            }

            .onAppear {
                greet(homeViewModel.greetOnFirstAppear)
            }

            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(action: homeViewModel.replayGreeting) {
                        Image(systemName: "speaker.wave.2.fill")
                    }
                    .accessibilityLabel("Hear the welcome again")
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(.blue)
                            Text("\(waterDropsCount)")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(.primary)
                        }
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        FlowerAlbumView()
                    } label: {
                        Image(systemName: "book.fill")
                    }
                    .accessibilityLabel("Flower album")
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(FlowerAlbumViewModel())
}
