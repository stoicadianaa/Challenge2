//
//  GameViewModel.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 20/11/2026.
//

import Foundation

final class GameViewModel {
    private let orderingGames: [Game] = [
        // MARK: Ordering - Easy
        Game(difficulty: .easy, content: .ordering(
            OrderingGameModel(title: "How does a chick grow up?", elements: [
                OrderingGameItem(emoji: "🥚", order: 0),
                OrderingGameItem(emoji: "🐥", order: 1),
                OrderingGameItem(emoji: "🐓", order: 2),
            ]))),
        Game(difficulty: .easy, content: .ordering(
            OrderingGameModel(title: "How does a tree grow?", elements: [
                OrderingGameItem(emoji: "🌰", order: 0),
                OrderingGameItem(emoji: "🌱", order: 1),
                OrderingGameItem(emoji: "🌳", order: 2),
            ]))),
        Game(difficulty: .easy, content: .ordering(
            OrderingGameModel(title: "Put in order from smallest to largest", elements: [
                OrderingGameItem(emoji: "🫐", order: 0),
                OrderingGameItem(emoji: "🍎", order: 1),
                OrderingGameItem(emoji: "🍉", order: 2),
            ]))),
        Game(difficulty: .easy, content: .ordering(
            OrderingGameModel(title: "Put in order from largest to smallest", elements: [
                OrderingGameItem(emoji: "🐋", order: 0),
                OrderingGameItem(emoji: "🐬", order: 1),
                OrderingGameItem(emoji: "🐟", order: 2),
            ]))),
        Game(difficulty: .easy, content: .ordering(
            OrderingGameModel(title: "Put in order from slowest to fastest", elements: [
                OrderingGameItem(emoji: "🐢", order: 0),
                OrderingGameItem(emoji: "🐇", order: 1),
                OrderingGameItem(emoji: "🐆", order: 2),
            ]))),
        Game(difficulty: .easy, content: .ordering(
            OrderingGameModel(title: "What happens first?", elements: [
                OrderingGameItem(emoji: "☁️", order: 0),
                OrderingGameItem(emoji: "🌧️", order: 1),
                OrderingGameItem(emoji: "🌈", order: 2),
            ]))),

        // MARK: Ordering - Medium
        Game(difficulty: .medium, content: .ordering(
            OrderingGameModel(title: "Put in order from youngest to oldest", elements: [
                OrderingGameItem(emoji: "👶", order: 0),
                OrderingGameItem(emoji: "🧒", order: 1),
                OrderingGameItem(emoji: "🧑", order: 2),
                OrderingGameItem(emoji: "🧓", order: 3),
            ]))),
        Game(difficulty: .medium, content: .ordering(
            OrderingGameModel(title: "Order the day, from morning to night", elements: [
                OrderingGameItem(emoji: "🌅", order: 0),
                OrderingGameItem(emoji: "☀️", order: 1),
                OrderingGameItem(emoji: "🌇", order: 2),
                OrderingGameItem(emoji: "🌙", order: 3),
            ]))),
        Game(difficulty: .medium, content: .ordering(
            OrderingGameModel(title: "Put the seasons in order, starting with spring", elements: [
                OrderingGameItem(emoji: "🌷", order: 0),
                OrderingGameItem(emoji: "☀️", order: 1),
                OrderingGameItem(emoji: "🍂", order: 2),
                OrderingGameItem(emoji: "❄️", order: 3),
            ]))),
        Game(difficulty: .medium, content: .ordering(
            OrderingGameModel(title: "Put in order from shortest to tallest", elements: [
                OrderingGameItem(emoji: "🐞", order: 0),
                OrderingGameItem(emoji: "🐱", order: 1),
                OrderingGameItem(emoji: "🐴", order: 2),
                OrderingGameItem(emoji: "🦒", order: 3),
            ]))),

        // MARK: Ordering - Hard
        // (none yet - add games with `difficulty: .hard`)

        // MARK: Math / Memory
        // (future game types go here)
    ]

    // MARK: Words - Word Match: every question is one game
    private let wordMatchGames: [Game] = WordMatchQuestion.all.map {
        Game(difficulty: .easy, content: .wordMatch($0))
    }

    var games: [Game] { orderingGames + wordMatchGames }

    func games(type: GameType, difficulty: Difficulty) -> [Game] {
        games.filter { $0.type == type && $0.difficulty == difficulty }
    }

    // all games of one type, easiest first. A type with no games returns [],
    // which is how the home screen knows to do nothing when its card is pressed.
    func games(for type: GameType) -> [Game] {
        games
            .filter { $0.type == type }
            .sorted { $0.difficulty < $1.difficulty }
    }

    // TODO (future task): track GameResult / SkillProgress per GameType and
    // add `record(_ result:)` to move the level up or down.
}
