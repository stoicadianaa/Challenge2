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
        case .tracing(let shape): "tracing:\(shape.title):\(difficulty.name)"
        case .oddOneOut(let model): "oddOneOut:" + model.key
        case .fruitDrag(let model): "fruitDrag:" + model.key
        case .mathMatch(let question): "mathMatch:" + question.key
        }
    }

    var type: GameType {
        switch content {
        case .ordering(let model): model.category
        case .oddOneOut: .logic
        case .mathMatch: .numbers
        case .wordMatch, .fruitDrag: .words
        case .tracing: .creativity
        }
    }
}

enum GameContent {
    case ordering(OrderingGameModel)
    case wordMatch(WordMatchQuestion)
    case tracing(TraceShape)
    case oddOneOut(OddOneOutGameModel)
    case fruitDrag(FruitDragGameModel)
    case mathMatch(MathQuestion)
}
