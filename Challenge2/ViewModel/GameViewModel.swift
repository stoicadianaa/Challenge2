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

        // MARK: Numbers - Number Order (the ordering template with digits; keep numbers to 2 digits so tiles fit)
        Game(difficulty: .easy, content: .ordering(
            OrderingGameModel(title: "Put the numbers in order, smallest first", elements: [
                OrderingGameItem(emoji: "1", order: 0),
                OrderingGameItem(emoji: "2", order: 1),
                OrderingGameItem(emoji: "3", order: 2),
            ], category: .numbers))),
        Game(difficulty: .easy, content: .ordering(
            OrderingGameModel(title: "Count up: put 4, 5 and 6 in order", elements: [
                OrderingGameItem(emoji: "4", order: 0),
                OrderingGameItem(emoji: "5", order: 1),
                OrderingGameItem(emoji: "6", order: 2),
            ], category: .numbers))),
        Game(difficulty: .easy, content: .ordering(
            OrderingGameModel(title: "Which comes first? Order from 7 to 9", elements: [
                OrderingGameItem(emoji: "7", order: 0),
                OrderingGameItem(emoji: "8", order: 1),
                OrderingGameItem(emoji: "9", order: 2),
            ], category: .numbers))),
        Game(difficulty: .easy, content: .ordering(
            OrderingGameModel(title: "Put the numbers in order, biggest first", elements: [
                OrderingGameItem(emoji: "3", order: 0),
                OrderingGameItem(emoji: "2", order: 1),
                OrderingGameItem(emoji: "1", order: 2),
            ], category: .numbers))),
        Game(difficulty: .medium, content: .ordering(
            OrderingGameModel(title: "Order the numbers from smallest to biggest", elements: [
                OrderingGameItem(emoji: "2", order: 0),
                OrderingGameItem(emoji: "5", order: 1),
                OrderingGameItem(emoji: "8", order: 2),
                OrderingGameItem(emoji: "10", order: 3),
            ], category: .numbers))),
        Game(difficulty: .medium, content: .ordering(
            OrderingGameModel(title: "Count by tens: put them in order", elements: [
                OrderingGameItem(emoji: "10", order: 0),
                OrderingGameItem(emoji: "20", order: 1),
                OrderingGameItem(emoji: "30", order: 2),
                OrderingGameItem(emoji: "40", order: 3),
            ], category: .numbers))),
        Game(difficulty: .medium, content: .ordering(
            OrderingGameModel(title: "Put the bigger numbers in order, biggest first", elements: [
                OrderingGameItem(emoji: "18", order: 0),
                OrderingGameItem(emoji: "14", order: 1),
                OrderingGameItem(emoji: "11", order: 2),
                OrderingGameItem(emoji: "7", order: 3),
            ], category: .numbers))),
        Game(difficulty: .medium, content: .ordering(
            OrderingGameModel(title: "Count by twos: what is the order?", elements: [
                OrderingGameItem(emoji: "2", order: 0),
                OrderingGameItem(emoji: "4", order: 1),
                OrderingGameItem(emoji: "6", order: 2),
                OrderingGameItem(emoji: "8", order: 3),
            ], category: .numbers))),
        Game(difficulty: .hard, content: .ordering(
            OrderingGameModel(title: "Order these numbers, smallest first", elements: [
                OrderingGameItem(emoji: "6", order: 0),
                OrderingGameItem(emoji: "13", order: 1),
                OrderingGameItem(emoji: "27", order: 2),
                OrderingGameItem(emoji: "45", order: 3),
                OrderingGameItem(emoji: "62", order: 4),
            ], category: .numbers))),
        Game(difficulty: .hard, content: .ordering(
            OrderingGameModel(title: "Order these numbers, biggest first", elements: [
                OrderingGameItem(emoji: "91", order: 0),
                OrderingGameItem(emoji: "74", order: 1),
                OrderingGameItem(emoji: "58", order: 2),
                OrderingGameItem(emoji: "33", order: 3),
                OrderingGameItem(emoji: "19", order: 4),
                OrderingGameItem(emoji: "5", order: 5),
            ], category: .numbers))),
        Game(difficulty: .hard, content: .ordering(
            OrderingGameModel(title: "Count by fives: put them in order", elements: [
                OrderingGameItem(emoji: "5", order: 0),
                OrderingGameItem(emoji: "10", order: 1),
                OrderingGameItem(emoji: "15", order: 2),
                OrderingGameItem(emoji: "20", order: 3),
                OrderingGameItem(emoji: "25", order: 4),
            ], category: .numbers))),
        Game(difficulty: .hard, content: .ordering(
            OrderingGameModel(title: "Put these numbers in order from the least to the most", elements: [
                OrderingGameItem(emoji: "9", order: 0),
                OrderingGameItem(emoji: "18", order: 1),
                OrderingGameItem(emoji: "36", order: 2),
                OrderingGameItem(emoji: "54", order: 3),
                OrderingGameItem(emoji: "72", order: 4),
                OrderingGameItem(emoji: "99", order: 5),
            ], category: .numbers))),
    ]

    // MARK: Numbers - Math Match: every question is one game, at the difficulty it declares
    private let mathMatchGames: [Game] = MathQuestion.all.map {
        Game(difficulty: $0.difficulty, content: .mathMatch($0))
    }

    // MARK: Words - Word Match: every question is one game, at the difficulty it declares
    private let wordMatchGames: [Game] = WordMatchQuestion.all.map {
        Game(difficulty: $0.difficulty, content: .wordMatch($0))
    }

    // MARK: Creativity - Tracing: every shape at every level (the level sets how strict tracing is)
    private let tracingGames: [Game] = Difficulty.allCases.flatMap { level in
        TraceShape.allCases.map { Game(difficulty: level, content: .tracing($0)) }
    }

    // MARK: Logic - Odd One Out: every puzzle is one game, at the difficulty it declares
    private let oddOneOutGames: [Game] = OddOneOutGameModel.all.map {
        Game(difficulty: $0.difficulty, content: .oddOneOut($0))
    }

    // MARK: Words - Fruit Drag: every letter is one game, at the difficulty it declares
    private let fruitDragGames: [Game] = FruitDragGameModel.all.map {
        Game(difficulty: $0.difficulty, content: .fruitDrag($0))
    }

    var games: [Game] { orderingGames + mathMatchGames + oddOneOutGames + wordMatchGames + fruitDragGames + tracingGames }

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
