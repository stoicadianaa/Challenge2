//
//  LanternSortingGameModel.swift
//  Challenge2
//
//  One game = one lantern pattern to finish. The session decides what comes next.
//

import Foundation

enum Lantern: String, Identifiable, CaseIterable {
    case leaf, acorn, flower

    var id: Self { self }
    var assetName: String { "lantern_\(rawValue)" }
    var title: String { "\(rawValue.capitalized) lantern" }
}

struct LanternSortingGameModel {
    let shown: [Lantern]       // the pattern the child sees
    let solution: [Lantern]    // what fills the empty spaces, in order
    let difficulty: Difficulty
    let hint: String

    var title: String {
        solution.count == 1 ? "Which lantern comes next?" : "Which lanterns come next?"
    }

    /// Stable across launches, so it can be saved in SkillProgress. Each pattern must be unique.
    var key: String { (shown + solution).map(\.rawValue).joined(separator: ",") }

    /// The whole pattern once it is finished.
    var completed: [Lantern] { shown + solution }

    // The number of empty spaces grows with the difficulty.
    static let all: [LanternSortingGameModel] = [
        // Easy: one space to fill.
        .init(shown: [.leaf, .acorn, .leaf, .acorn, .leaf], solution: [.acorn], difficulty: .easy,
              hint: "A leaf, then an acorn. What comes after the leaf?"),
        .init(shown: [.flower, .leaf, .flower, .leaf, .flower], solution: [.leaf], difficulty: .easy,
              hint: "A flower, then a leaf. What comes after the flower?"),
        .init(shown: [.acorn, .flower, .acorn, .flower, .acorn], solution: [.flower], difficulty: .easy,
              hint: "An acorn, then a flower. What comes after the acorn?"),

        // Medium: two spaces to fill.
        .init(shown: [.leaf, .acorn, .leaf, .acorn], solution: [.leaf, .acorn], difficulty: .medium,
              hint: "Two spaces to fill. Start with the first one."),
        .init(shown: [.flower, .acorn, .flower, .acorn], solution: [.flower, .acorn], difficulty: .medium,
              hint: "Two spaces to fill. Start with the first one."),
        .init(shown: [.leaf, .flower, .leaf, .flower], solution: [.leaf, .flower], difficulty: .medium,
              hint: "Two spaces to fill. Start with the first one."),

        // Hard: a group of three that repeats.
        .init(shown: [.leaf, .acorn, .flower], solution: [.leaf, .acorn, .flower], difficulty: .hard,
              hint: "Find the group of three and repeat it."),
        .init(shown: [.flower, .flower, .leaf], solution: [.flower, .flower, .leaf], difficulty: .hard,
              hint: "Find the group of three and repeat it."),
        .init(shown: [.acorn, .leaf, .leaf], solution: [.acorn, .leaf, .leaf], difficulty: .hard,
              hint: "Find the group of three and repeat it."),
    ]
}
