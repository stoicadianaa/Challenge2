//
//  OddOneOutViewModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import Foundation
import Observation

// One Odd One Out game = one puzzle. The session decides what comes next.
@MainActor
@Observable
final class OddOneOutViewModel {

    let coach: MascotCoach

    private(set) var game: OddOneOutGameModel
    private(set) var isSolved = false
    private(set) var wrongTiles: Set<Int> = []
    private(set) var shakes: [Int: Int] = [:]   // how many times each wrong tile was tapped

    init(game: OddOneOutGameModel, coach: MascotCoach? = nil) {
        var shuffled = game
        shuffled.shuffle()
        self.game = shuffled
        self.coach = coach ?? MascotCoach()
    }

    func tap(_ index: Int) {
        guard !isSolved, !wrongTiles.contains(index) else { return }

        if index == game.oddIndex {
            isSolved = true
            coach.say(game.praise)
        } else {
            wrongTiles.insert(index)
            shakes[index, default: 0] += 1
            coach.say("Try again! You can do it!")
        }
    }
}
