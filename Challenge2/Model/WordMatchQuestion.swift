//
//  WordMatchQuestion.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import Foundation

struct WordMatchQuestion: Identifiable {
    let id = UUID()
    let emoji: String
    let word: String
    let choices: [String]
    // Last, with a default, so the easy questions below stay as they were.
    var difficulty: Difficulty = .easy

    // The questions of the game: add or remove lines to change the length
    static let all = [
        WordMatchQuestion(emoji: "🐥", word: "CHICK",  choices: ["CHICK", "DUCK", "BIRD"]),
        WordMatchQuestion(emoji: "🍎", word: "APPLE",  choices: ["BANANA", "APPLE", "ORANGE"]),
        WordMatchQuestion(emoji: "🐱", word: "CAT",    choices: ["DOG", "CAT", "BEAR"]),
        WordMatchQuestion(emoji: "🌳", word: "TREE",   choices: ["FLOWER", "TREE", "GRASS"]),
        WordMatchQuestion(emoji: "🐟", word: "FISH",   choices: ["FISH", "FROG", "TURTLE"]),
        WordMatchQuestion(emoji: "☀️", word: "SUN",    choices: ["MOON", "STAR", "SUN"]),

        // Medium: 4 choices that look alike, so the child has to read each word.
        // Each word must be unique across ALL questions: it is the game's saved key.
        WordMatchQuestion(emoji: "🐶", word: "DOG",   choices: ["DIG", "DOG", "DUG", "DOT"], difficulty: .medium),
        WordMatchQuestion(emoji: "🚌", word: "BUS",   choices: ["BUN", "BUG", "BUS", "BAT"], difficulty: .medium),
        WordMatchQuestion(emoji: "🐸", word: "FROG",  choices: ["FROM", "FLAG", "FROG", "FOG"], difficulty: .medium),
        WordMatchQuestion(emoji: "🌙", word: "MOON",  choices: ["MOON", "SOON", "ROOM", "MOOD"], difficulty: .medium),
        WordMatchQuestion(emoji: "🏠", word: "HOUSE", choices: ["HORSE", "MOUSE", "HOUSE", "HOSE"], difficulty: .medium),
        WordMatchQuestion(emoji: "🐝", word: "BEE",   choices: ["BED", "SEE", "BEE", "BEET"], difficulty: .medium),
        WordMatchQuestion(emoji: "🦁", word: "LION",  choices: ["LIME", "LION", "LAMB", "LIP"], difficulty: .medium),

        // Hard: long words and choices that start the same way.
        WordMatchQuestion(emoji: "🦋", word: "BUTTERFLY",  choices: ["BUTTERCUP", "BUTTER", "BUTTERFLY", "FLY"], difficulty: .hard),
        WordMatchQuestion(emoji: "🐘", word: "ELEPHANT",   choices: ["ELEVATOR", "ELEPHANT", "ELEVEN", "ELBOW"], difficulty: .hard),
        WordMatchQuestion(emoji: "🌈", word: "RAINBOW",    choices: ["RAINDROP", "RAINCOAT", "ARROW", "RAINBOW"], difficulty: .hard),
        WordMatchQuestion(emoji: "🍓", word: "STRAWBERRY", choices: ["BLUEBERRY", "RASPBERRY", "STRAWBERRY", "CHERRY"], difficulty: .hard),
        WordMatchQuestion(emoji: "🌻", word: "SUNFLOWER",  choices: ["SUNSHINE", "SUNSET", "SUNFLOWER", "SUNDAY"], difficulty: .hard),
        WordMatchQuestion(emoji: "🚀", word: "ROCKET",     choices: ["POCKET", "SOCKET", "ROCKET", "ROCK"], difficulty: .hard),
        WordMatchQuestion(emoji: "🐢", word: "TURTLE",     choices: ["TURKEY", "TURTLE", "TUNNEL", "TABLE"], difficulty: .hard),
    ]
}
