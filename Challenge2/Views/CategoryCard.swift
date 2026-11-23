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

    var body: some View {
        card
    }

    private var card: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                Spacer(minLength: 0)

                icon

                Spacer(minLength: 0)

                Text(title)
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.25), radius: 2, y: 1)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, minHeight: 240, maxHeight: 260)
            .glassEffect(.regular.tint(cardColor.opacity(0.55)),
                         in: .rect(cornerRadius: 36))
        }
         .accessibilityLabel(title)
    }

    private var icon: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.25))
                .frame(width: 130, height: 130)

            if let emoji {
                Text(emoji)
                    .font(.system(size: 80))
            } else if let customIcon = customCenterIcon {
                Image(systemName: customIcon)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundStyle(.white)
                    .symbolRenderingMode(.hierarchical)
            } else {
                Text(mainSymbolText)
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
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
            self.init(title: game.name, emoji: text, cardColor: game.color, action: action)
        case .systemImage(let name):
            self.init(title: game.name, customCenterIcon: name, cardColor: game.color, action: action)
        case .asset:
            self.init(title: game.name, cardColor: game.color, action: action)
        }
    }
}
