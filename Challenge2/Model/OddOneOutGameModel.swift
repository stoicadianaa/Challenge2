//
//  OddOneOutGameModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import SwiftUI

struct OddOneOutGameModel {
    let title = "Which one is different?"

    let difficulty: Difficulty

    private(set) var group: [OddOneOutItem]  // what the other tiles show (one item, or different ones)
    private(set) var odd: OddOneOutItem      // shown once
    // Set for "these are all flowers" puzzles; nil when the other tiles are the same picture.
    let groupName: String?
    private(set) var oddIndex: Int           // where the odd one is (0..<tileCount)
    private(set) var tint: Color

    // Same picture on every tile except one.
    init(_ first: OddOneOutItem, _ second: OddOneOutItem, difficulty: Difficulty = .easy) {
        group = [first]
        odd = second
        groupName = nil
        self.difficulty = difficulty
        oddIndex = 0
        tint = .blue
    }

    // A group of different things of one kind, and one thing that doesn't belong.
    init(group name: String, _ emojis: [String], odd: OddOneOutItem, difficulty: Difficulty) {
        group = emojis.map { OddOneOutItem(emoji: $0) }
        self.odd = odd
        groupName = name
        self.difficulty = difficulty
        oddIndex = 0
        tint = .blue
    }

    // More tiles and more look-alike pictures make a puzzle harder.
    var tileCount: Int {
        switch difficulty {
        case .easy: 3
        case .medium: 4
        case .hard: 6
        }
    }

    // What the mascot says when the odd one is found.
    var praise: String {
        if let groupName {
            return "Yes! These are all \(groupName), but this is \(odd.withArticle)."
        }
        let count = ["Zero", "One", "Two", "Three", "Four", "Five", "Six"][tileCount - 1]
        return "Yes! \(count) \(group[0].plural) and one \(odd.single)."
    }

    /// Stable across launches, so it can be saved in SkillProgress. Each puzzle must be unique.
    var key: String { (groupName ?? group[0].single) + "|" + odd.single }

    func item(at index: Int) -> OddOneOutItem {
        if index == oddIndex { return odd }
        // Skip the odd tile when counting, then go round the group (it repeats if it is short).
        let position = index > oddIndex ? index - 1 : index
        return group[position % group.count]
    }

    // Picks which item is the odd one, where it goes and the color.
    // Called when a game starts, so playing the same puzzle twice doesn't look the same.
    mutating func shuffle() {
        // A group puzzle keeps its roles (the outsider can't become the group).
        if groupName == nil, Bool.random() { (group[0], odd) = (odd, group[0]) }
        group.shuffle()
        oddIndex = Int.random(in: 0..<tileCount)
        tint = Self.tints.randomElement() ?? .blue
    }

    private static let tints: [Color] = [.blue, .green, .orange, .pink, .purple]

    static let all: [OddOneOutGameModel] = [
        // Easy: 3 tiles. The other tiles are different things of one kind, the odd one is something else.
        OddOneOutGameModel(group: "flowers", ["🌷", "🌹", "🌻"],
                           odd: OddOneOutItem(emoji: "🌳", single: "tree"), difficulty: .easy),
        OddOneOutGameModel(group: "animals", ["🐶", "🐱", "🐰"],
                           odd: OddOneOutItem(emoji: "🍎", single: "apple"), difficulty: .easy),
        OddOneOutGameModel(group: "fruits", ["🍌", "🍓", "🍇"],
                           odd: OddOneOutItem(emoji: "🚗", single: "car"), difficulty: .easy),
        OddOneOutGameModel(group: "vehicles", ["🚌", "🚲", "🚂"],
                           odd: OddOneOutItem(emoji: "🏠", single: "house"), difficulty: .easy),

        // Medium: 4 tiles.
        OddOneOutGameModel(group: "fruits", ["🍎", "🍌", "🍇"],
                           odd: OddOneOutItem(emoji: "🥕", single: "carrot"), difficulty: .medium),
        OddOneOutGameModel(group: "pets", ["🐶", "🐱", "🐹"],
                           odd: OddOneOutItem(emoji: "🦁", single: "lion"), difficulty: .medium),
        OddOneOutGameModel(group: "things with wheels", ["🚗", "🚌", "🚲"],
                           odd: OddOneOutItem(emoji: "⛵️", single: "boat"), difficulty: .medium),
        OddOneOutGameModel(group: "balls", ["⚽️", "🏀", "🎾"],
                           odd: OddOneOutItem(emoji: "🎸", single: "guitar"), difficulty: .medium),
        OddOneOutGameModel(group: "farm animals", ["🐮", "🐷", "🐔"],
                           odd: OddOneOutItem(emoji: "🐘", single: "elephant"), difficulty: .medium),

        // Hard: 6 tiles, an outsider that is easy to mix up with the group.
        OddOneOutGameModel(group: "fruits", ["🍎", "🍌", "🍇", "🍓", "🍊"],
                           odd: OddOneOutItem(emoji: "🥦", single: "broccoli"), difficulty: .hard),
        OddOneOutGameModel(group: "vegetables", ["🥕", "🌽", "🥔", "🍆", "🧅"],
                           odd: OddOneOutItem(emoji: "🍎", single: "apple"), difficulty: .hard),
        OddOneOutGameModel(group: "birds", ["🐦", "🦆", "🦉", "🦅", "🐧"],
                           odd: OddOneOutItem(emoji: "🦇", single: "bat"), difficulty: .hard),
        OddOneOutGameModel(group: "insects", ["🐝", "🐞", "🦋", "🐜", "🦗"],
                           odd: OddOneOutItem(emoji: "🕷️", single: "spider"), difficulty: .hard),

        OddOneOutGameModel(group: "farm animals", ["🐮", "🐷", "🐔", "🐑", "🐴"],
                           odd: OddOneOutItem(emoji: "🦌", single: "deer"), difficulty: .hard),
        OddOneOutGameModel(group: "musical instruments", ["🎸", "🎹", "🥁", "🎺", "🎻"],
                           odd: OddOneOutItem(emoji: "🎮", single: "game controller"), difficulty: .hard),
        OddOneOutGameModel(group: "vehicles", ["🚗", "🚌", "🚂", "🚕", "🚑"],
                           odd: OddOneOutItem(emoji: "🐎", single: "horse"), difficulty: .hard),
    ]
}
