//
//  OrderingGameViewModel.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 18/11/2026.
//

import Foundation

final class OrderingGameViewModel {
    var games: [OrderingGameModel] = [
        OrderingGameModel(title: "How does a chick grow up?", elements: [
            OrderingGameItem(emoji: "🥚", order: 0),
            OrderingGameItem(emoji: "🐥", order: 1),
            OrderingGameItem(emoji: "🐓", order: 2),
        ]),
        OrderingGameModel(title: "How does a tree grow?", elements: [
            OrderingGameItem(emoji: "🌰", order: 0),
            OrderingGameItem(emoji: "🌱", order: 1),
            OrderingGameItem(emoji: "🌳", order: 2),
        ]),
        OrderingGameModel(title: "Put in order from smallest to largest", elements: [
            OrderingGameItem(emoji: "🫐", order: 0),
            OrderingGameItem(emoji: "🍎", order: 1),
            OrderingGameItem(emoji: "🍉", order: 2),
        ]),
        OrderingGameModel(title: "Put in order from largest to smallest", elements: [
            OrderingGameItem(emoji: "🐋", order: 0),
            OrderingGameItem(emoji: "🐬", order: 1),
            OrderingGameItem(emoji: "🐟", order: 2),
        ]),
        OrderingGameModel(title: "Put in order from slowest to fastest", elements: [
            OrderingGameItem(emoji: "🐢", order: 0),
            OrderingGameItem(emoji: "🐇", order: 1),
            OrderingGameItem(emoji: "🐆", order: 2),
        ]),
        OrderingGameModel(title: "What happens first?", elements: [
            OrderingGameItem(emoji: "☁️", order: 0),
            OrderingGameItem(emoji: "🌧️", order: 1),
            OrderingGameItem(emoji: "🌈", order: 2),
        ]),
        OrderingGameModel(title: "Put in order from youngest to oldest", elements: [
            OrderingGameItem(emoji: "👶", order: 0),
            OrderingGameItem(emoji: "🧒", order: 1),
            OrderingGameItem(emoji: "🧑", order: 2),
            OrderingGameItem(emoji: "🧓", order: 3),
        ]),
        OrderingGameModel(title: "Order the day, from morning to night", elements: [
            OrderingGameItem(emoji: "🌅", order: 0),
            OrderingGameItem(emoji: "☀️", order: 1),
            OrderingGameItem(emoji: "🌇", order: 2),
            OrderingGameItem(emoji: "🌙", order: 3),
        ]),
        OrderingGameModel(title: "Put the seasons in order, starting with spring", elements: [
            OrderingGameItem(emoji: "🌷", order: 0),
            OrderingGameItem(emoji: "☀️", order: 1),
            OrderingGameItem(emoji: "🍂", order: 2),
            OrderingGameItem(emoji: "❄️", order: 3),
        ]),
        OrderingGameModel(title: "Put in order from shortest to tallest", elements: [
            OrderingGameItem(emoji: "🐞", order: 0),
            OrderingGameItem(emoji: "🐱", order: 1),
            OrderingGameItem(emoji: "🐴", order: 2),
            OrderingGameItem(emoji: "🦒", order: 3),
        ]),
    ]
}
