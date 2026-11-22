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

    // The questions of the game: add or remove lines to change the length
    static let all = [
        WordMatchQuestion(emoji: "🐥", word: "CHICK",  choices: ["CHICK", "DUCK", "BIRD"]),
        WordMatchQuestion(emoji: "🍎", word: "APPLE",  choices: ["BANANA", "APPLE", "ORANGE"]),
        WordMatchQuestion(emoji: "🐱", word: "CAT",    choices: ["DOG", "CAT", "BEAR"]),
        WordMatchQuestion(emoji: "🌳", word: "TREE",   choices: ["FLOWER", "TREE", "GRASS"]),
        WordMatchQuestion(emoji: "🐟", word: "FISH",   choices: ["FISH", "FROG", "TURTLE"]),
        WordMatchQuestion(emoji: "☀️", word: "SUN",    choices: ["MOON", "STAR", "SUN"])
    ]
}
