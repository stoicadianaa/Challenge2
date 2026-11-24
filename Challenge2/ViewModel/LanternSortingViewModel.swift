//
//  LanternSortingViewModel.swift
//  Challenge2
//
//  The state of one lantern game: which lanterns the child placed, and what
//  the mascot says about it. The session decides what comes next.
//

import Foundation
import Observation

@MainActor
@Observable
final class LanternSortingViewModel {

    let coach: MascotCoach
    let game: LanternSortingGameModel

    private(set) var answers: [Lantern?]
    private(set) var isSolved = false
    private(set) var wrongChecks = 0

    init(game: LanternSortingGameModel, coach: MascotCoach? = nil) {
        self.game = game
        self.coach = coach ?? MascotCoach()
        answers = Array(repeating: nil, count: game.solution.count)
    }

    var isComplete: Bool { !answers.contains(nil) }
    var canPlace: Bool { !isSolved && answers.contains(nil) }

    /// Fills the first empty space.
    func place(_ lantern: Lantern) {
        guard !isSolved, let index = answers.firstIndex(of: nil) else { return }
        answers[index] = lantern
    }

    /// Takes a lantern back out of its space.
    func remove(at index: Int) {
        guard !isSolved, answers.indices.contains(index) else { return }
        answers[index] = nil
    }

    func check() {
        guard !isSolved, isComplete else { return }

        if answers == game.solution.map({ Optional($0) }) {
            isSolved = true
            coach.say("You found the pattern!")
        } else {
            wrongChecks += 1
            // Keep what is right, clear what is wrong.
            for index in answers.indices where answers[index] != game.solution[index] {
                answers[index] = nil
            }
            coach.say("Good try! Look at the pattern again.")
            coach.say(game.hint)
        }
    }
}
