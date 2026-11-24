//
//  FruitDragViewModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 23/11/2026.
//

import Foundation
import Observation
internal import CoreGraphics

// One Fruit Drag game = one letter. The session decides what comes next.
@MainActor
@Observable
final class FruitDragViewModel {

    let coach: MascotCoach

    private(set) var game: FruitDragGameModel
    private(set) var isSolved = false
    private(set) var wrongCount = 0
    private(set) var isHoveringLetter = false   // a fruit is being dragged over the letter

    // Set by the view: where the letter is on the screen
    @ObservationIgnored var letterFrame: CGRect = .zero

    init(game: FruitDragGameModel, coach: MascotCoach? = nil) {
        var shuffled = game
        shuffled.shuffle()
        self.game = shuffled
        self.coach = coach ?? MascotCoach()
    }

    var letter: String { String(game.letter) }

    var title: String { "Drag the fruit that starts with the letter \(letter)" }

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
            isSolved = true
            coach.say("\(fruit.letter) is for \(fruit.name)! Great job!")
            return true
        }

        wrongCount += 1
        coach.say("That is \(fruit.withArticle). \(fruit.letter) is for \(fruit.name). Try again!")
        return false
    }

    private func isOverLetter(_ point: CGPoint) -> Bool {
        guard !letterFrame.isEmpty else { return false }
        return letterFrame.insetBy(dx: -30, dy: -30).contains(point)
    }
}
