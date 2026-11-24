//
//  DashboardComponents.swift
//  Challenge2
//
//  The building blocks of the parent dashboard: a card, a progress row per
//  category and a small stat tile.
//

import SwiftUI

/// The rounded frosted panel every dashboard section sits on.
struct DashboardCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(20)
            .frame(maxWidth: 760, alignment: .leading)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 30))
    }
}

/// One category: its emoji, the level the child is on and a bar toward the next level.
struct ProgressRow: View {
    let type: GameType
    let progress: SkillProgress

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                if case .text(let emoji) = type.symbol {
                    Text(emoji)
                }

                Text(type.name)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))

                Spacer()

                Text(progress.level.name)
                    .font(.system(.footnote, design: .rounded, weight: .bold))
                    .foregroundStyle(type.color)
            }

            ProgressView(value: progress.levelCompletion)
                .tint(type.color)
        }
        .accessibilityElement(children: .combine)
        .accessibilityValue("\(progress.level.name), \(Int(progress.levelCompletion * 100)) percent")
    }
}

/// A number with a caption, e.g. "12 / 20" under "Flowers".
struct StatTile: View {
    let value: String
    let title: String
    let systemImage: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(color)

            Text(value)
                .font(.system(.title3, design: .rounded, weight: .bold))

            Text(title)
                .font(.system(.caption, design: .rounded, weight: .semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    DashboardCard {
        VStack(spacing: 16) {
            ProgressRow(type: .words, progress: SkillProgress(level: .medium, winStreak: 2))
            HStack {
                StatTile(value: "12", title: "Water drops", systemImage: "drop.fill", color: .blue)
                StatTile(value: "3 / 9", title: "Flowers", systemImage: "camera.macro", color: .pink)
            }
        }
    }
    .padding()
}
