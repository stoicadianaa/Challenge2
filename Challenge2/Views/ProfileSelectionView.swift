//
//  ProfileSelectionView.swift
//  Challenge2
//
//  Created by Gennara Vettoliere on 20/11/2026.
//

import SwiftUI
import UIKit

struct ProfileSelectionView: View {

    // Shared with the screens after this one, so progress saved there isn't overwritten here.
    @ObservedObject var store: ProfileStore
    var onSelect: (ChildProfile) -> Void = { _ in }
    @State private var showCreator = false
    @State private var profileToDelete: ChildProfile?
    @State private var appeared = false

    @Environment(\.screenSize) private var screen
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled
    @State private var viewModel = ProfileSelectionViewModel()

    // Smaller avatars on a phone so two fit side by side in portrait.
    private var avatarSize: CGFloat { screen.value(regular: 150, portrait: 110, landscape: 90) }

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: avatarSize + 40, maximum: avatarSize + 90),
                  spacing: screen.isCompact ? 16 : 28)]
    }

    var body: some View {
        ZStack() {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Everything sits in one centered block; it only scrolls when it can't fit.
            ScrollIfNeeded {
            VStack(spacing: screen.isCompact ? 12 : 24) {
                Spacer(minLength: 0)

                // Same tappable, spoken title as the home screen.
                InstructionButton(text: ProfileSelectionViewModel.question, speak: viewModel.replay)

                Image("mascot_genderless_happy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screen.value(regular: 280, portrait: 160, landscape: 90))
                    .accessibilityHidden(true)

                grid

                Spacer(minLength: 0)
            }
            .padding(.vertical, 20)
            }
        }
        .overlay{
                if showCreator {
                    ZStack{
                        Color.black.opacity(0.35)
                            .ignoresSafeArea()
                            .transition(.opacity)
                    
                    ProfileCreatorView(
                        onSave: { profile in
                            store.add(profile)
                            withAnimation(.spring()) { showCreator = false }
                        },
                        onCancel: {
                            withAnimation(.spring()) { showCreator = false }
                        }
                    )
                    .transition(.scale(scale: 0.85)
                        .combined(with: .opacity))
                }
                    .transition(.opacity)
            }
    }
        .alert(
            "Delete this profile?",
            isPresented: Binding(
                get: { profileToDelete != nil },
                set: { if !$0 { profileToDelete = nil } }
            )
        ) {
            Button("Delete", role: .destructive) {
                if let p = profileToDelete { store.delete(p) }
                profileToDelete = nil
            }
            Button("Cancel", role: .cancel) { profileToDelete = nil }
        } message: {
            Text("\(profileToDelete?.name ?? "This profile") will be removed.")
        }
        .onAppear {
            // VoiceOver already reads the screen, so the spoken question would talk over it.
            if !voiceOverEnabled { viewModel.greetOnFirstAppear() }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.65)) {
                appeared = true
            }
            if store.profiles.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring()) { showCreator = true }
                }
            }
        }
    }

    private var grid: some View {
                LazyVGrid(columns: columns, spacing: screen.isCompact ? 20 : 32) {
                    ForEach(
                        Array(store.profiles.enumerated()),
                        id: \.element.id
                    ) { index, profile in
                        profileCard(
                            profile,
                            color: PF.ring[index % PF.ring.count]
                        )
                    }
                    if store.profiles.count < ProfileStore.maxProfiles {
                        addCard
                    }
                }
                .padding(.horizontal, screen.isCompact ? 20 : 40)
                .scaleEffect(appeared ? 1 : 0.9)
                .opacity(appeared ? 1 : 0)
    }

    private func profileCard(_ profile: ChildProfile, color: Color) -> some View {
        Button {
            onSelect(profile)
        } label: {
            VStack(spacing: 12) {
                AvatarCircle(emoji: profile.avatar, size: avatarSize, ring: color)

                Text(profile.name)
                    .font(.system(size: screen.isCompact ? 20 : 26, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 6)
                    .glassEffect(.regular, in: .capsule)
            }
        }
        .buttonStyle(BouncyStyle())
        .contextMenu {
            Button(role: .destructive) {
                profileToDelete = profile
            } label: {
                Label("Delete profile", systemImage: "trash")
            }
        }
        .accessibilityLabel(profile.name)
        .accessibilityHint("Double tap to play. Touch and hold to delete.")
    }

    
    private var addCard: some View {
        Button {
            withAnimation(.spring()) { showCreator = true }
        } label: {
            VStack(spacing: 12) {
                    Image(systemName: "plus")
                    .font(.system(size: avatarSize * 0.4, weight: .bold))
                    .foregroundColor(.secondary)
                    .frame(width: avatarSize, height: avatarSize)
                    .glassEffect(.regular.tint(.green.opacity(0.15)), in: .circle)
                
                .frame(width: avatarSize, height: avatarSize)
                .shadow(color: .black.opacity(0.15), radius: 6, y: 4)

                Text("New player")
                    .font(.system(size: screen.isCompact ? 20 : 26, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .glassEffect(.regular, in: .capsule)
            }
        }
        .buttonStyle(BouncyStyle())
    }
}

#Preview {
    ProfileSelectionView(store: ProfileStore())
}
