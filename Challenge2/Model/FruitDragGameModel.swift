//
//  FruitDragGameModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 23/11/2026.
//

import Foundation

// One game = one letter at one difficulty. The session decides what comes next.
struct FruitDragGameModel {
    let letter: Character
    let difficulty: Difficulty
    private(set) var target: FruitItem      // the fruit that starts with the letter
    private(set) var options: [FruitItem]   // the fruits shown: the target and the wrong ones

    init(letter: Character, difficulty: Difficulty) {
        let first = Self.fruits(for: letter).first ?? FruitItem.all[0]
        self.letter = letter
        self.difficulty = difficulty
        target = first
        options = [first]
    }

    // More fruits to choose from make a game harder.
    var optionCount: Int {
        switch difficulty {
        case .easy: 2
        case .medium: 3
        case .hard: 4
        }
    }

    /// Stable across launches, so it can be saved in SkillProgress. Each game must be unique.
    var key: String { "\(letter):\(difficulty.name)" }

    func isTarget(_ fruit: FruitItem) -> Bool {
        fruit == target
    }

    // Picks which fruit is the right one and which wrong fruits go with it (always with a different initial).
    // Called when a game starts, so playing the same letter twice doesn't look the same.
    mutating func shuffle() {
        if let newTarget = Self.fruits(for: letter).randomElement() {
            target = newTarget
        }

        let others = FruitItem.all.filter { $0.letter != letter }
        let groups = Dictionary(grouping: others, by: { $0.letter })
        let wrong = groups.values.compactMap { $0.randomElement() }.shuffled().prefix(optionCount - 1)

        options = ([target] + Array(wrong)).shuffled()
    }

    private static func fruits(for letter: Character) -> [FruitItem] {
        FruitItem.all.filter { $0.letter == letter }
    }

    static let all: [FruitDragGameModel] = [
        // Easy: 2 fruits. Letters whose fruit everybody knows.
        FruitDragGameModel(letter: "A", difficulty: .easy),
        FruitDragGameModel(letter: "B", difficulty: .easy),
        FruitDragGameModel(letter: "L", difficulty: .easy),
        FruitDragGameModel(letter: "S", difficulty: .easy),

        // Medium: 3 fruits.
        FruitDragGameModel(letter: "C", difficulty: .medium),
        FruitDragGameModel(letter: "G", difficulty: .medium),
        FruitDragGameModel(letter: "K", difficulty: .medium),
        FruitDragGameModel(letter: "O", difficulty: .medium),
        FruitDragGameModel(letter: "W", difficulty: .medium),

        // Hard: 4 fruits, and letters with more than one possible fruit.
        FruitDragGameModel(letter: "B", difficulty: .hard),
        FruitDragGameModel(letter: "C", difficulty: .hard),
        FruitDragGameModel(letter: "M", difficulty: .hard),
        FruitDragGameModel(letter: "P", difficulty: .hard),
    ]
}
