//
//  WordMatchViewModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import SwiftUI

// One Word Match game = one question. The session decides what comes next.
@MainActor
@Observable
final class WordMatchViewModel {

    let question: WordMatchQuestion
    let mascot: Mascot

    var selectedAnswer: String?          // set when the child finds the right word
    var wrongAnswers: Set<String> = []   // wrong words already tried

    // What the mascot is saying right now. The bubble shows exactly this, so it is
    // visible for the whole time the line is spoken and never when nothing is said.
    private(set) var mascotLine: String?

    @ObservationIgnored private let speaker: Speaking
    @ObservationIgnored private var lastEncouragement: String?
    @ObservationIgnored private var pendingLines: [String] = []   // waiting for their turn
    @ObservationIgnored private var speechTask: Task<Void, Never>?

    // `mascot` and `speaker` are optional and resolved in the body: a default argument
    // such as `.neutral` or `Speaker.shared` is evaluated outside the main actor.
    init(
        question: WordMatchQuestion,
        mascot: Mascot? = nil,
        speaker: Speaking? = nil
    ) {
        self.question = question
        self.mascot = mascot ?? .neutral
        self.speaker = speaker ?? Speaker.shared
    }

    var isAnswered: Bool { selectedAnswer != nil }

    // The mascot's reply to a tap. Ignored while the mascot (or the instruction)
    // is still talking, so a tap can never cut a line short.
    func encourage() {
        guard mascotLine == nil, pendingLines.isEmpty, !speaker.isSpeaking else { return }
        let message = mascot.encouragement(avoiding: lastEncouragement)
        lastEncouragement = message
        say(message)
    }

    func choose(_ choice: String) {
        guard !isAnswered else { return }

        if choice == question.word {
            selectedAnswer = choice
            say("Amazing! Well done!")
        } else {
            wrongAnswers.insert(choice)
            say("Try again! You can do it!")
        }
    }

    // The instruction button. It has no bubble, so it waits while the mascot is talking.
    func speakInstruction() {
        guard mascotLine == nil else { return }
        speaker.say("Find the correct word!")
    }

    /// Returns once the mascot has finished everything it had to say.
    func waitUntilMascotIsQuiet() async {
        await speechTask?.value
    }

    // MARK: Mascot speech

    // Lines never overwrite each other: a new line waits until the current one is finished.
    private func say(_ line: String) {
        guard line != mascotLine, !pendingLines.contains(line) else { return }
        pendingLines.append(line)
        guard speechTask == nil else { return }
        speechTask = Task { await speakPendingLines() }
    }

    private func speakPendingLines() async {
        while !pendingLines.isEmpty {
            let line = pendingLines.removeFirst()
            mascotLine = line               // bubble appears...
            await speaker.sayAndWait(line)  // ...stays for the whole line...
            mascotLine = nil                // ...and goes when the line is done
        }
        speechTask = nil
    }
}
