//
//  OrderingGameModel.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 18/11/2026.
//

import Foundation
import SwiftUI

struct OrderingGameModel {
    let title: String
    var elements: [OrderingGameItem]
    // Which category the game belongs to: number games reuse this template under Numbers.
    var category: GameType = .logic
    
    var isInCorrectOrder: Bool {
        elements.map(\.order) == elements.map(\.order).sorted()
    }
    
    mutating func shuffle() {
        elements.shuffle()
        // A random shuffle can land on the solution (1 in 6 with 3 items): never start solved.
        while elements.count > 1 && isInCorrectOrder {
            elements.shuffle()
        }
    }
    
    mutating func apply(_ difference: ReorderDifference<OrderingGameItem.ID, ReorderableSingleCollectionIdentifier>) {
        let moved = elements.filter { difference.sources.contains($0.id) }
        elements.removeAll { difference.sources.contains($0.id) }

        switch difference.destination.position {
        case .before(let targetID):
            if let index = elements.firstIndex(where: { $0.id == targetID }) {
                elements.insert(contentsOf: moved, at: index)
            }
        case .end:
            elements.append(contentsOf: moved)
        }
    }
}
