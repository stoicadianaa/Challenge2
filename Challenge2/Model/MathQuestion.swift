//
//  MathQuestion.swift
//  Challenge2
//
//  One Math Match game = one question: a picture or a sum, and numbers to choose from.
//

import Foundation

struct MathQuestion: Identifiable {
    let id = UUID()
    let title: String        // the instruction, read aloud: "How many apples?"
    let prompt: String       // shown big in the card: "🍎🍎🍎", "4 + 3", "? + 6 = 14"
    let answer: Int
    let choices: [Int]       // includes the answer; the view model shuffles them
    var difficulty: Difficulty = .easy

    /// Stable across launches, so it can be saved in SkillProgress.
    /// Each prompt must be unique across ALL questions.
    var key: String { prompt }

    // Counting pictures: `count` copies of one emoji.
    private static func counting(_ emoji: String, _ name: String, count: Int, choices: [Int]) -> MathQuestion {
        MathQuestion(title: "How many \(name) can you count?",
                     prompt: String(repeating: emoji, count: count),
                     answer: count, choices: choices)
    }

    static let all: [MathQuestion] = [
        // Easy: count up to 5, 3 choices.
        counting("🍎", "apples", count: 3, choices: [2, 3, 4]),
        counting("🐥", "chicks", count: 2, choices: [1, 2, 3]),
        counting("⭐️", "stars", count: 4, choices: [3, 5, 4]),
        counting("🌷", "flowers", count: 5, choices: [4, 5, 3]),
        counting("🐟", "fish", count: 1, choices: [1, 2, 3]),
        counting("🎈", "balloons", count: 4, choices: [4, 2, 5]),

        // Medium: adding and taking away within 10, 4 choices that sit close together.
        MathQuestion(title: "What is 2 plus 3?", prompt: "2 + 3", answer: 5, choices: [4, 5, 6, 3], difficulty: .medium),
        MathQuestion(title: "What is 4 plus 4?", prompt: "4 + 4", answer: 8, choices: [7, 9, 8, 6], difficulty: .medium),
        MathQuestion(title: "What is 6 plus 3?", prompt: "6 + 3", answer: 9, choices: [8, 9, 10, 7], difficulty: .medium),
        MathQuestion(title: "What is 5 minus 2?", prompt: "5 − 2", answer: 3, choices: [2, 4, 3, 7], difficulty: .medium),
        MathQuestion(title: "What is 9 minus 4?", prompt: "9 − 4", answer: 5, choices: [6, 5, 4, 13], difficulty: .medium),
        MathQuestion(title: "What is 7 minus 3?", prompt: "7 − 3", answer: 4, choices: [3, 5, 4, 10], difficulty: .medium),

        // Hard: within 20, and a missing number to find.
        // TODO(human): add 2-3 more hard questions of your own (see the Learn by Doing note).
        MathQuestion(title: "What is 8 plus 7?", prompt: "8 + 7", answer: 15, choices: [14, 15, 16, 17], difficulty: .hard),
        MathQuestion(title: "What is 12 plus 6?", prompt: "12 + 6", answer: 18, choices: [17, 19, 18, 16], difficulty: .hard),
        MathQuestion(title: "What is 15 minus 8?", prompt: "15 − 8", answer: 7, choices: [6, 8, 7, 9], difficulty: .hard),
        MathQuestion(title: "What is 17 minus 9?", prompt: "17 − 9", answer: 8, choices: [7, 9, 8, 6], difficulty: .hard),
        MathQuestion(title: "Which number is missing?", prompt: "? + 6 = 14", answer: 8, choices: [7, 8, 9, 20], difficulty: .hard),
        MathQuestion(title: "Which number is missing?", prompt: "11 − ? = 4", answer: 7, choices: [6, 7, 8, 15], difficulty: .hard),
    ]
}
