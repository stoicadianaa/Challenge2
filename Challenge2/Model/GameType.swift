//
//  GameType.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 20/11/2026.
//

import Foundation
import SwiftUI

enum GameType: CaseIterable, Identifiable {
    case ordering, math, memory, words

    var id: Self { self }

    var name: String {
        switch self {
        case .ordering: "Squirrel's Acorn Line"
        case .math: "Busy Bee Counting"
        case .memory: "Wise Owl"
        case .words: "Talking Parrot"
        }
    }

    var spokenName: String {
        switch self {
        case .ordering: "Squirrel's Acorn Line"
        case .math: "Busy Bee Counting"
        case .memory: "Wise Owl"
        case .words: "Talking Parrot"
        }
    }

    var symbol: GameSymbol {
        switch self {
        case .ordering: .text("🐿️")
        case .math: .text("🐝")
        case .memory: .text("🦉")
        case .words: .text("🦜")
        }
    }
    var color: Color {
        switch self {
        case .ordering: .brown
        case .math: .yellow
        case .memory: .purple
        case .words: .green
        }
    }
}

enum GameSymbol {
    case text(String)  // e.g. "12+3"
    case systemImage(String)  // SF Symbol name
    case asset(String)  // name in Assets.xcassets
}
