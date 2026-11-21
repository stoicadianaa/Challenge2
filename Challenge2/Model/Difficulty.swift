//
//  Difficulty.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 20/11/2026.
//

import Foundation

enum Difficulty: Int, CaseIterable, Identifiable, Comparable {
    case easy, medium, hard

    var id: Self { self }

    var name: String {
        switch self {
        case .easy: "Easy"
        case .medium: "Medium"
        case .hard: "Hard"
        }
    }

    static func < (lhs: Difficulty, rhs: Difficulty) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
