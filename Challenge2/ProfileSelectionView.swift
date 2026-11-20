//
//  ProfileSelectionView.swift
//  Challenge2
//
//  Created by Gennara Vettoliere on 20/11/2026.
//

import SwiftUI
import UIKit

struct ProfileSelectionView: View {

    var onSelect: (ChildProfile) -> Void = { _ in }

    @StateObject private var store = ProfileStore()
    @State private var showCreator = false
    @State private var profileToDelete: ChildProfile?
    @State private var appeared = false

    private let columns = [
        GridItem(.adaptive(minimum: 190, maximum: 240), spacing: 28)
    ]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                LazyVGrid(columns: columns, spacing: 32) {
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
                .padding(.horizontal, 40)
                .padding(.vertical, 20)

                if showCreator {
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
                    .transition(.scale(scale: 0.85).combined(with: .opacity))
                }
            }
            .navigationTitle("Who's playing?")
        }
        .ignoresSafeArea(.container, edges: .all)
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

    private func profileCard(_ profile: ChildProfile, color: Color) -> some View
    {
        Button {
            onSelect(profile)
        } label: {
            VStack(spacing: 12) {
                AvatarCircle(emoji: profile.avatar, size: 150, ring: color)

                Text(profile.name)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(PF.brown)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 6)
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
    }

    private var addCard: some View {
        Button {
            withAnimation(.spring()) { showCreator = true }
        } label: {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(PF.paper.opacity(0.85))
                        .overlay(
                            Circle().stroke(
                                .green,
                                style: StrokeStyle(
                                    lineWidth: 6,
                                    dash: [12, 10]
                                )
                            )
                        )
                    Image(systemName: "plus")
                        .font(.system(size: 60, weight: .heavy))
                        .foregroundColor(.green)
                }
                .frame(width: 150, height: 150)
                .shadow(color: .black.opacity(0.15), radius: 6, y: 4)

                Text("New player")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(PF.brown)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 6)
            }
        }
        .buttonStyle(BouncyStyle())
    }
}

#Preview {
    ProfileSelectionView()
}
