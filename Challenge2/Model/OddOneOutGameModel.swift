//
//  OddOneOutGameModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import SwiftUI

struct OddOneOutGameModel {
    static let tileCount = 4

    let title = "Which one is different?"

    private(set) var common: OddOneOutItem   // shown 3 times
    private(set) var odd: OddOneOutItem      // shown once
    private(set) var oddIndex: Int           // where the odd one is (0...3)
    private(set) var tint: Color

    init(_ first: OddOneOutItem, _ second: OddOneOutItem) {
        common = first
        odd = second
        oddIndex = 0
        tint = .blue
    }

    func item(at index: Int) -> OddOneOutItem {
        index == oddIndex ? odd : common
    }

    // Picks which item is the odd one, where it goes and the color.
    //Called when a game starts, so playing the same puzzle twice doesn't look the same.
    mutating func shuffle() {
        if Bool.random() { (common, odd) = (odd, common) }
        oddIndex = Int.random(in: 0..<Self.tileCount)
        tint = Self.tints.randomElement() ?? .blue
    }

    private static let tints: [Color] = [.blue, .green, .orange, .pink, .purple]

    static let all: [OddOneOutGameModel] = [
        OddOneOutGameModel(
            OddOneOutItem(emoji: "🍎", single: "red apple", plural: "red apples"),
            OddOneOutItem(emoji: "🍏", single: "green apple", plural: "green apples")),
        OddOneOutGameModel(
            OddOneOutItem(emoji: "🍌", single: "banana", plural: "bananas"),
            OddOneOutItem(emoji: "🥝", single: "kiwi", plural: "kiwis")),
        OddOneOutGameModel(
            OddOneOutItem(emoji: "🍓", single: "strawberry", plural: "strawberries"),
            OddOneOutItem(emoji: "🍒", single: "cherry", plural: "cherries")),
        OddOneOutGameModel(
            OddOneOutItem(emoji: "🍊", single: "orange", plural: "oranges"),
            OddOneOutItem(emoji: "🍋", single: "lemon", plural: "lemons")),
        OddOneOutGameModel(
            OddOneOutItem(emoji: "🍇", single: "grape", plural: "grapes"),
            OddOneOutItem(emoji: "🍉", single: "watermelon", plural: "watermelons")),
        OddOneOutGameModel(
            OddOneOutItem(emoji: "🐶", single: "dog", plural: "dogs"),
            OddOneOutItem(emoji: "🐱", single: "cat", plural: "cats")),
        OddOneOutGameModel(
            OddOneOutItem(emoji: "🚗", single: "car", plural: "cars"),
            OddOneOutItem(emoji: "🚌", single: "bus", plural: "buses")),
        OddOneOutGameModel(
            OddOneOutItem(emoji: "⭐️", single: "star", plural: "stars"),
            OddOneOutItem(emoji: "🌙", single: "moon", plural: "moons")),
        OddOneOutGameModel(
            OddOneOutItem(emoji: "⚽️", single: "soccer ball", plural: "soccer balls"),
            OddOneOutItem(emoji: "🏀", single: "basketball", plural: "basketballs")),
        OddOneOutGameModel(
            OddOneOutItem(emoji: "🐟", single: "fish", plural: "fish"),
            OddOneOutItem(emoji: "🐦", single: "bird", plural: "birds")),
    ]
}
