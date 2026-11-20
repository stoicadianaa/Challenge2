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

    var type: GameType {
        switch content {
        case .ordering: .ordering
        }
    }
}

enum GameContent {
    case ordering(OrderingGameModel)
}
