//
//  Game.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 20/11/2026.
//

import Foundation

struct Game: Identifiable {
    let id = UUID()
    let difficulty: Difficulty
    let content: GameContent
    /// Water drops this game is worth when completed.
    var drops = 1

    var type: GameType {
        switch content {
        case .ordering: .logic
        case .wordMatch: .words
        }
    }
}

enum GameContent {
    case ordering(OrderingGameModel)
    case wordMatch(WordMatchQuestion)
}
