//
//  FruitDragGameModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 23/11/2026.
//

import Foundation

struct FruitDragGameModel {
    let letter: Character
    private(set) var target: FruitItem      // the fruit that starts with the letter
    private(set) var options: [FruitItem]   // the 3 fruits shown: the target and 2 wrong ones

    init(letter: Character) {
        let first = Self.fruits(for: letter).first ?? FruitItem.all[0]
        self.letter = letter
        target = first
        options = [first]
    }

    func isTarget(_ fruit: FruitItem) -> Bool {
        fruit == target
    }

    // Picks which fruit is the right one and which 2 wrong fruits go with it (always with an different initial).
    mutating func shuffle() {
        if let newTarget = Self.fruits(for: letter).randomElement() {
            target = newTarget
        }

        let others = FruitItem.all.filter { $0.letter != letter }
        let groups = Dictionary(grouping: others, by: { $0.letter })
        let wrong = groups.values.compactMap { $0.randomElement() }.shuffled().prefix(2)

        options = ([target] + Array(wrong)).shuffled()
    }

    private static func fruits(for letter: Character) -> [FruitItem] {
        FruitItem.all.filter { $0.letter == letter }
    }

    static let all: [FruitDragGameModel] = Set(FruitItem.all.map { $0.letter })
        .sorted()
        .map { FruitDragGameModel(letter: $0) }
}
