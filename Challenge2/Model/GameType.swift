//
//  GameType.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 20/11/2026.
//

import Foundation
import SwiftUI

enum GameType: CaseIterable, Identifiable {
    case words, numbers, logic, creativity

    var id: Self { self }

    var name: String {
        switch self {
        case .words: "Words"
        case .numbers: "Numbers"
        case .logic: "Logic"
        case .creativity: "Creativity"
        }
    }

    var spokenName: String { name }

    /// "A, B, C, or D" — for reading every category aloud.
    static var spokenList: String {
        let names = allCases.map(\.spokenName)
        guard let last = names.last, names.count > 1 else { return names.first ?? "" }
        return names.dropLast().joined(separator: ", ") + ", or " + last
    }

    var symbol: GameSymbol {
        switch self {
        case .words: .text("🔡")
        case .numbers: .text("🧠")
        case .logic: .text("🧩")
        case .creativity: .text("🎨")
        }
    }

    var color: Color {
        switch self {
        case .words: Color(red: 0.35, green: 0.6, blue: 0.9)
        case .numbers: Color(red: 0.45, green: 0.75, blue: 0.3)
        case .logic: Color(red: 0.98, green: 0.72, blue: 0.3)
        case .creativity: Color(red: 0.95, green: 0.5, blue: 0.45)
        }
    }
}

enum GameSymbol {
    case text(String)  // e.g. "12+3"
    case systemImage(String)  // SF Symbol name
    case asset(String)  // name in Assets.xcassets
}
