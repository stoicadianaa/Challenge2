//
//  HomeView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 18/11/2026.
//

import SwiftUI

struct HomeView: View {

    @State private var homeViewModel = HomeViewModel()

    // The child playing: levels, water drops and plant. Every change goes back
    // to the owner (ProfileStore) to be saved.
    @State private var profile: ChildProfile
    private let onChange: (ChildProfile) -> Void
    // Goes back to "Who's playing?". Everything is already saved, so nothing is lost.
    private let onSwitchProfile: () -> Void

    init(
        profile: ChildProfile = ChildProfile(name: "", avatar: ""),
        onChange: @escaping (ChildProfile) -> Void = { _ in },
        onSwitchProfile: @escaping () -> Void = {}
    ) {
        _profile = State(initialValue: profile)
        self.onChange = onChange
        self.onSwitchProfile = onSwitchProfile
    }

    private func save(_ change: (inout ChildProfile) -> Void) {
        change(&profile)
        onChange(profile)
    }

    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled
    @Environment(\.screenSize) private var screen

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

    // Four cards in a row on iPad and iPhone landscape; a 2x2 grid on a phone held upright.
    @ViewBuilder
    private var cards: some View {
        if screen.isPhonePortrait {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                categoryCards
            }
        } else {
            HStack(spacing: screen.isCompact ? 12 : 20) {
                categoryCards
            }
        }
    }

    private var categoryCards: some View {
        ForEach(GameType.allCases) { game in
            CategoryCard(game: game) {
                // Categories without games do nothing when pressed.
                play(game)
            }
        }
    }

    private var content: some View {
        VStack(spacing: screen.isCompact ? 12 : 16) {

            Spacer()

            InstructionButton(text: "Welcome to WonderBloom!", speak: homeViewModel.replayGreeting)

            Image("mascot_genderless_happy")
                .resizable()
                .scaledToFit()
                .frame(width: screen.value(regular: 350, portrait: 200, landscape: 110))
                .accessibilityHidden(true)

            cards
            .frame(maxWidth: .infinity)
            .padding(.horizontal, screen.isCompact ? 0 : 10)

            Spacer()
        }
        .padding()
    }

    var body: some View {
        NavigationStack {
            ScrollIfNeeded { content }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                GameSessionView(
                    type: type,
                    games: viewModel,
                    progress: profile.progress[type] ?? SkillProgress(),
                    onProgressChange: { updated in save { $0.progress[type] = updated } },
                    onFinish: { drops in save { $0.waterDrops += drops } }
                )
            }

            .onAppear {
                greet(homeViewModel.greetOnFirstAppear)
            }

            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onSwitchProfile) {
                        Image(systemName: "person.2.fill")
                    }
                    .accessibilityLabel("Change player")
                }

                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        GardenView(
                            waterDrops: profile.waterDrops,
                            plantDrops: profile.plantDrops,
                            unlockedFlowers: profile.unlockedFlowers
                        ) {
                            water, plant in
                            save { $0.waterDrops = water; $0.plantDrops = plant }
                        } onFlowerCompleted: {
                            save { $0.unlockNextFlower() }
                            return profile.unlockedFlowers
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(.blue)
                            Text("\(profile.waterDrops)")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(.primary)
                        }
                    }
                    .accessibilityLabel("My garden, \(profile.waterDrops) water drops")
                }

                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        FlowerAlbumView(unlockedFlowers: profile.unlockedFlowers)
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
}
