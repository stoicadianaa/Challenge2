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

    /// Stable across launches (`id` is a new UUID every time), so it can be saved in SkillProgress.
    var key: String {
        switch content {
        case .ordering(let model): "ordering:" + model.title
        case .wordMatch(let question): "wordMatch:" + question.word
        }
    }

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
