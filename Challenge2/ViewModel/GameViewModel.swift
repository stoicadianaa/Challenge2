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
        // 5-6 items: the ordering screen shrinks the emoji to fit.
        Game(difficulty: .hard, content: .ordering(
            OrderingGameModel(title: "Put in order from the smallest to the biggest", elements: [
                OrderingGameItem(emoji: "🐜", order: 0),
                OrderingGameItem(emoji: "🐭", order: 1),
                OrderingGameItem(emoji: "🐈", order: 2),
                OrderingGameItem(emoji: "🐕", order: 3),
                OrderingGameItem(emoji: "🐘", order: 4),
                OrderingGameItem(emoji: "🐋", order: 5),
            ]))),
        Game(difficulty: .hard, content: .ordering(
            OrderingGameModel(title: "Put the day in order, from sunrise to bedtime", elements: [
                OrderingGameItem(emoji: "🌅", order: 0),
                OrderingGameItem(emoji: "☀️", order: 1),
                OrderingGameItem(emoji: "🌇", order: 2),
                OrderingGameItem(emoji: "🌃", order: 3),
                OrderingGameItem(emoji: "🛌", order: 4),
            ]))),
        Game(difficulty: .hard, content: .ordering(
            OrderingGameModel(title: "What happens to a flower, first to last?", elements: [
                OrderingGameItem(emoji: "🌰", order: 0),
                OrderingGameItem(emoji: "🌱", order: 1),
                OrderingGameItem(emoji: "🌿", order: 2),
                OrderingGameItem(emoji: "🌷", order: 3),
                OrderingGameItem(emoji: "🍂", order: 4),
            ]))),
        Game(difficulty: .hard, content: .ordering(
            OrderingGameModel(title: "Put the numbers in order, from 1 to 5", elements: [
                OrderingGameItem(emoji: "1️⃣", order: 0),
                OrderingGameItem(emoji: "2️⃣", order: 1),
                OrderingGameItem(emoji: "3️⃣", order: 2),
                OrderingGameItem(emoji: "4️⃣", order: 3),
                OrderingGameItem(emoji: "5️⃣", order: 4),
            ]))),
        Game(difficulty: .hard, content: .ordering(
            OrderingGameModel(title: "Which is slowest? Order them like a race, slowest first", elements: [
                OrderingGameItem(emoji: "🐌", order: 0),
                OrderingGameItem(emoji: "🐢", order: 1),
                OrderingGameItem(emoji: "🚲", order: 2),
                OrderingGameItem(emoji: "🚗", order: 3),
                OrderingGameItem(emoji: "🚄", order: 4),
                OrderingGameItem(emoji: "✈️", order: 5),
            ]))),

        // MARK: Math / Memory
        // (future game types go here)
    ]

    // MARK: Words - Word Match: every question is one game, at the difficulty it declares
    private let wordMatchGames: [Game] = WordMatchQuestion.all.map {
        Game(difficulty: $0.difficulty, content: .wordMatch($0))
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

    /// The next game for a child: a random one at their level, unseen first.
    /// If their level has no games, uses the nearest level that has some
    /// (the easier one wins a tie). Returns nil only if the type has no games at all.
    func nextGame(type: GameType, progress: SkillProgress) -> Game? {
        let ofType = games.filter { $0.type == type }
        let target = progress.level.rawValue
        guard let level = Set(ofType.map(\.difficulty)).min(by: {
            (abs($0.rawValue - target), $0.rawValue) < (abs($1.rawValue - target), $1.rawValue)
        }) else { return nil }

        let candidates = ofType.filter { $0.difficulty == level }
        let unseen = candidates.filter { !progress.recentlyPlayed.contains($0.key) }
        if let game = unseen.randomElement() { return game }

        // Everything at this level was played: start over, but not with the game just played.
        let others = candidates.filter { $0.key != progress.recentlyPlayed.last }
        return (others.isEmpty ? candidates : others).randomElement()
    }
}
