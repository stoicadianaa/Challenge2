//
//  FruitDragViewModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 23/11/2026.
//

import Foundation
import Observation
internal import CoreGraphics

@MainActor
@Observable
final class FruitDragViewModel {

    private static let celebrationTime: Duration = .seconds(2.4)

    private(set) var game: FruitDragGameModel
    private(set) var isSolved = false
    private(set) var wrongFruit: FruitItem?     // the last wrong fruit, so the child can learn it
    private(set) var wrongCount = 0
    private(set) var isHoveringLetter = false   // a fruit is being dragged over the letter

    // Set by the view: where the letter is on the screen
    @ObservationIgnored var letterFrame: CGRect = .zero

    @ObservationIgnored private let speaker: Speaking
    @ObservationIgnored private let onCorrect: () -> Void
    @ObservationIgnored private var finishTask: Task<Void, Never>?

    init(game: FruitDragGameModel, speaker: Speaking? = nil, onCorrect: @escaping () -> Void) {
        var shuffled = game
        shuffled.shuffle()
        self.game = shuffled
        self.speaker = speaker ?? Speaker.shared
        self.onCorrect = onCorrect
    }

    var letter: String { String(game.letter) }

    var title: String { "Drag the fruit that starts with “\(letter)”" }

    var instruction: String { "Drag the fruit that starts with the letter \(letter)" }

    var mascotImage: String {
        if isSolved { return "mascot_genderless_celebrating" }
        if wrongFruit != nil { return "mascot_genderless_neutral" }
        return "mascot_genderless_happy"
    }

    var feedback: String {
        if isSolved { return "Great job!" }
        if let wrongFruit { return wrongMessage(for: wrongFruit) }
        return "Drag the right fruit onto the letter!"
    }

    private func wrongMessage(for fruit: FruitItem) -> String {
        "That is \(fruit.withArticle). \(fruit.letter) is for \(fruit.name). Try again!"
    }

    func speakInstruction() {
        speaker.say(instruction)
    }

    func dragMoved(to point: CGPoint) {
        guard !isSolved else { return }
        isHoveringLetter = isOverLetter(point)
    }

    func dropped(_ fruit: FruitItem, at point: CGPoint) -> Bool {
        isHoveringLetter = false
        guard isOverLetter(point) else { return false }
        return choose(fruit)
    }

    func choose(_ fruit: FruitItem) -> Bool {
        guard !isSolved else { return false }

        if game.isTarget(fruit) {
            solve(fruit)
            return true
        }

        wrongFruit = fruit
        wrongCount += 1
        speaker.say(wrongMessage(for: fruit))
        return false
    }

    func stop() {
        finishTask?.cancel()
    }

    private func solve(_ fruit: FruitItem) {
        isSolved = true
        wrongFruit = nil
        speaker.say("\(fruit.letter) is for \(fruit.name)!")

        finishTask = Task {
            try? await Task.sleep(for: Self.celebrationTime)
            guard !Task.isCancelled else { return }
            onCorrect()
        }
    }

    private func isOverLetter(_ point: CGPoint) -> Bool {
        guard !letterFrame.isEmpty else { return false }
        return letterFrame.insetBy(dx: -30, dy: -30).contains(point)
    }
}
