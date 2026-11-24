//
//  OddOneOutViewModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//


import Foundation
import Observation

@MainActor
@Observable
final class OddOneOutViewModel {

    private static let celebrationTime: Duration = .seconds(2.5)

    private(set) var game: OddOneOutGameModel
    private(set) var isSolved = false
    private(set) var wrongTiles: Set<Int> = []
    private(set) var shakes: [Int: Int] = [:]   // how many times each wrong tile was tapped

    @ObservationIgnored private let speaker: Speaking
    @ObservationIgnored private let onCorrect: () -> Void
    @ObservationIgnored private var finishTask: Task<Void, Never>?

    init(game: OddOneOutGameModel, speaker: Speaking? = nil, onCorrect: @escaping () -> Void) {
        var shuffled = game
        shuffled.shuffle()
        self.game = shuffled
        self.speaker = speaker ?? Speaker.shared
        self.onCorrect = onCorrect
    }

    var mascotImage: String {
        if isSolved { return "mascot_genderless_celebrating" }
        if !wrongTiles.isEmpty { return "mascot_genderless_neutral" }
        return "mascot_genderless_happy"
    }

    var feedback: String {
        if isSolved { return "Great job!" }
        if !wrongTiles.isEmpty { return "Not this one. Try again!" }
        return "Tap the one that is different!"
    }

    func speakInstruction() {
        speaker.say("\(game.title) Tap the odd one out!")
    }

    func tap(_ index: Int) {
        guard !isSolved, !wrongTiles.contains(index) else { return }

        if index == game.oddIndex {
            isSolved = true
            speaker.say("Yes! Three \(game.common.plural) and one \(game.odd.single).")

            // Leave time for the cross and the celebration, then tell the session.
            finishTask = Task {
                try? await Task.sleep(for: Self.celebrationTime)
                guard !Task.isCancelled else { return }
                onCorrect()
            }
        } else {
            wrongTiles.insert(index)
            shakes[index, default: 0] += 1
            speaker.say("Try again!")
        }
    }

    func stop() {
        finishTask?.cancel()
    }
}
