//
//  MascotCoach.swift
//  Challenge2
//
//  The mascot's voice, shared by every game: what the bubble says, when it
//  is shown, and the speech that goes with it. A game owns one coach, tells it
//  what to say (`say`), and gives MascotView `line` and `encourage()`.
//

import Observation

@MainActor
@Observable
final class MascotCoach {

    let mascot: Mascot

    // What the mascot is saying right now. The bubble shows exactly this, so it is
    // visible for the whole time the line is spoken and never when nothing is said.
    private(set) var line: String?

    @ObservationIgnored private let speaker: Speaking
    @ObservationIgnored private var lastEncouragement: String?
    @ObservationIgnored private var pendingLines: [String] = []   // waiting for their turn
    @ObservationIgnored private var speechTask: Task<Void, Never>?

    // `mascot` and `speaker` are optional and resolved in the body: a default argument
    // such as `.neutral` or `Speaker.shared` is evaluated outside the main actor.
    init(mascot: Mascot? = nil, speaker: Speaking? = nil) {
        self.mascot = mascot ?? .neutral
        self.speaker = speaker ?? Speaker.shared
    }

    /// True when the mascot has nothing to say and nothing waiting.
    var isQuiet: Bool { line == nil && pendingLines.isEmpty && !speaker.isSpeaking }

    /// The mascot's reply to a tap. Ignored while the mascot (or an instruction)
    /// is still talking, so a tap can never cut a line short.
    func encourage() {
        guard isQuiet else { return }
        let message = mascot.encouragement(avoiding: lastEncouragement)
        lastEncouragement = message
        say(message)
    }

    /// Lines never overwrite each other: a new line waits until the current one is finished.
    func say(_ text: String) {
        guard text != line, !pendingLines.contains(text) else { return }
        pendingLines.append(text)
        guard speechTask == nil else { return }
        speechTask = Task { await speakPendingLines() }
    }

    /// Like `say`, but skipped if the mascot is busy. For hints that must not pile up.
    func sayIfQuiet(_ text: String) {
        guard isQuiet else { return }
        say(text)
    }

    /// Reads an instruction aloud without a bubble. Skipped while the mascot is talking.
    func speakInstruction(_ text: String) {
        guard line == nil else { return }
        speaker.say(text)
    }

    /// Returns once the mascot has finished everything it had to say.
    func waitUntilQuiet() async {
        await speechTask?.value
    }

    private func speakPendingLines() async {
        while !pendingLines.isEmpty {
            let next = pendingLines.removeFirst()
            line = next                    // bubble appears...
            await speaker.sayAndWait(next) // ...stays for the whole line...
            line = nil                     // ...and goes when the line is done
        }
        speechTask = nil
    }
}
