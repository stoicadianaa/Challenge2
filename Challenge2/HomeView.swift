//
//  HomeView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 18/11/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var waterDropsCount = 0

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
                    CategoryCard(
                        title: "Words",
                        emoji: "🔡",
                        cardColor: Color(red: 0.35, green: 0.6, blue: 0.9)
                    ) { play(.words) }
                    
                    CategoryCard(
                        title: "Numbers",
                        emoji: "🧠",
                        cardColor: Color(red: 0.45, green: 0.75, blue: 0.3)
                    ) { play(.math) }
                    
                    CategoryCard(
                        title: "Logic",
                        emoji: "🧩",
                        cardColor: Color(red: 0.98, green: 0.72, blue: 0.3)
                    ) { play(.ordering) }
                    
                    CategoryCard(
                        title: "Creativity",
                        emoji: "🎨",
                        customCenterIcon: "paintpalette.fill",
                        cardColor: Color(red: 0.95, green: 0.5, blue: 0.45)
                    ) {}
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

            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
