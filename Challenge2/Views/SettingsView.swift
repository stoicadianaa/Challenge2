//
//  SettingsView.swift
//  Challenge2
//
//  The parent dashboard: settings plus how the current child is doing,
//  read straight from their saved profile.
//

import SwiftUI

struct SettingsView: View {
    let profile: ChildProfile

    @Environment(\.screenSize) private var screen

    @AppStorage("soundEffectsEnabled") private var soundEffectsEnabled = true

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image("mascot_genderless_neutral")
                    .resizable()
                    .scaledToFit()
                    .frame(height: screen.value(regular: 180, portrait: 120, landscape: 80))
                    .accessibilityHidden(true)

                header
                stats
                progress
            }
            .padding(.horizontal, screen.isCompact ? 16 : 32)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .accessibilityHidden(true)
        )
        .navigationTitle("Parent Dashboard")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        DashboardCard {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.name.isEmpty ? "Your explorer" : profile.name)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                    Text("See how your little explorer is growing!")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Divider()

                Toggle(isOn: $soundEffectsEnabled) {
                    Label("Sound Effects", systemImage: "speaker.wave.2.fill")
                        .font(.system(.body, design: .rounded, weight: .medium))
                }
                .tint(.green)
            }
        }
    }

    private var stats: some View {
        DashboardCard {
            HStack {
                StatTile(
                    value: "\(profile.waterDrops)",
                    title: "Water drops",
                    systemImage: "drop.fill",
                    color: .blue
                )
                StatTile(
                    value: "\(profile.unlockedFlowers.count) / \(Flower.catalog.count)",
                    title: "Flowers",
                    systemImage: "camera.macro",
                    color: .pink
                )
            }
        }
    }

    private var progress: some View {
        DashboardCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Learning Progress")
                    .font(.system(.title3, design: .rounded, weight: .bold))

                ForEach(GameType.allCases) { type in
                    // A category never played has no entry yet: it starts at Easy.
                    ProgressRow(type: type, progress: profile.progress[type] ?? SkillProgress())
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(profile: ChildProfile(name: "Emma", avatar: ""))
    }
    .providesScreenSize()
}
