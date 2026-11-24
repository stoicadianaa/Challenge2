//
//  FruitItem.swift
//  Challenge2
//
//  Created by Miriam Stellato on 23/11/2026.
//

import Foundation

struct FruitItem: Identifiable, Hashable {
    let emoji: String
    let name: String
    var isPlural = false   // "grapes": no "a" or "an" in front

    var id: String { name }

    var letter: Character { Character(name.prefix(1).uppercased()) }

    var withArticle: String {
        if isPlural { return name.lowercased() }
        let article = "AEIOU".contains(letter) ? "an" : "a"
        return "\(article) \(name.lowercased())"
    }

    static let all: [FruitItem] = [
        FruitItem(emoji: "🍎", name: "Apple"),
        FruitItem(emoji: "🥑", name: "Avocado"),
        FruitItem(emoji: "🍌", name: "Banana"),
        FruitItem(emoji: "🫐", name: "Blueberries", isPlural: true),
        FruitItem(emoji: "🍒", name: "Cherry"),
        FruitItem(emoji: "🥥", name: "Coconut"),
        FruitItem(emoji: "🍇", name: "Grapes", isPlural: true),
        FruitItem(emoji: "🥝", name: "Kiwi"),
        FruitItem(emoji: "🍋", name: "Lemon"),
        FruitItem(emoji: "🥭", name: "Mango"),
        FruitItem(emoji: "🍈", name: "Melon"),
        FruitItem(emoji: "🍊", name: "Orange"),
        FruitItem(emoji: "🍑", name: "Peach"),
        FruitItem(emoji: "🍐", name: "Pear"),
        FruitItem(emoji: "🍍", name: "Pineapple"),
        FruitItem(emoji: "🍓", name: "Strawberry"),
        FruitItem(emoji: "🍉", name: "Watermelon"),
    ]
}
