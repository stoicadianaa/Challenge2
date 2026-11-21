//
//  HomeViewModel.swift
//  Challenge2
//
//  Decides what the home screen says and when. The view only forwards events.
//

import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    // Add more lines here to vary the welcome.
    static let greetings = [
        "Hi! I'm Bloomy. Welcome to WonderBloom! Pick a game: \(GameType.spokenList).",
        "Hi friend! Let's make our garden bloom. What do you want to play?",
        "Welcome back! Ready to play?",
        "Let's grow some flowers today! Pick a game.",
    ]

    // Chosen once, so the replay button repeats what the child just heard.
    private(set) var greeting: String
    private var hasGreeted = false
    @ObservationIgnored private let speaker: Speaking

    // `speaker` is optional and resolved in the body: a default argument of
    // `Speaker.shared` is evaluated outside the main actor.
    init(speaker: Speaking? = nil, greeting: String? = nil) {
        self.speaker = speaker ?? Speaker.shared
        self.greeting = greeting ?? Self.greetings.randomElement() ?? Self.greetings[0]
    }

    /// Autoplay: speaks only the first time, so coming back from a game stays quiet.
    func greetOnFirstAppear() {
        guard !hasGreeted else { return }
        hasGreeted = true
        replayGreeting()
    }

    /// Speaker button in the nav bar.
    func replayGreeting() {
        speaker.say(greeting)
    }
}
