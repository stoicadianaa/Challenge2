//
//  CategoryCard.swift
//  Challenge2
//
//  Created by Miriam Stellato on 18/11/2026.
//

import SwiftUI

struct CategoryCard: View {
    let title: String
    var emoji: String? = nil
    var mainSymbolText: String = ""
    var customCenterIcon: String? = nil
    let cardColor: Color
    let action: () -> Void

    @Environment(\.screenSize) private var screen

    var body: some View {
        card
    }

    private var card: some View {
        Button(action: action) {
            VStack(spacing: screen.isCompact ? 8 : 16) {
                Spacer(minLength: 0)

                icon

                Spacer(minLength: 0)

                Text(title)
                    .font(.system(size: screen.value(regular: 26, portrait: 22, landscape: 20), weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.25), radius: 2, y: 1)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .padding(.vertical, screen.isCompact ? 12 : 24)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity,
                   minHeight: screen.value(regular: 240, portrait: 150, landscape: 120),
                   maxHeight: screen.value(regular: 260, portrait: 170, landscape: 140))
            .glassEffect(.regular.tint(cardColor.opacity(0.55)),
                         in: .rect(cornerRadius: 36))
        }
        .accessibilityLabel(title)
    }

    private var iconCircle: CGFloat { screen.value(regular: 130, portrait: 84, landscape: 64) }

    private var icon: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.25))
                .frame(width: iconCircle, height: iconCircle)

            if let emoji {
                Text(emoji)
                    .font(.system(size: iconCircle * 0.62))
            } else if let customIcon = customCenterIcon {
                Image(systemName: customIcon)
                    .font(.system(size: iconCircle * 0.46, weight: .bold))
                    .foregroundStyle(.white)
                    .symbolRenderingMode(.hierarchical)
            } else {
                Text(mainSymbolText)
                    .font(.system(size: iconCircle * 0.37, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
        }
        .accessibilityHidden(true)
    }
}

extension CategoryCard {
    /// Builds a card from a game type, so the enum stays the single source of
    /// truth for each category's name, symbol and color.
    init(game: GameType, action: @escaping () -> Void) {
        switch game.symbol {
        case .text(let text):
            self.init(
                title: game.name,
                emoji: text,
                cardColor: game.color,
                action: action
            )
        case .systemImage(let name):
            self.init(
                title: game.name,
                customCenterIcon: name,
                cardColor: game.color,
                action: action
            )
        case .asset:
            self.init(title: game.name, cardColor: game.color, action: action)
        }
    }
}
