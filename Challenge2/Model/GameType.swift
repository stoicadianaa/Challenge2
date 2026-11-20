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
        case .ordering: "Ordering"
        case .math: "Math"
        case .memory: "Memory"
        case .words: "Words"
        }
    }

    var symbol: GameSymbol {
        switch self {
        case .ordering: .systemImage("arrow.up.arrow.down")
        case .math: .text("12+3")
        case .memory: .systemImage("brain.fill")
        case .words: .text("Abc")
        }
    }

    var color: Color {
        switch self {
        case .ordering: .orange
        case .math: .blue
        case .memory: .purple
        case .words: .green
        }
    }
}

enum GameSymbol {
      case text(String)          // e.g. "12+3"
      case systemImage(String)   // SF Symbol name
      case asset(String)         // name in Assets.xcassets
  }
