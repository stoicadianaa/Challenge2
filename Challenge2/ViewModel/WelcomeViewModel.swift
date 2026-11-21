//
//  WelcomeViewModel.swift
//  Challenge2
//
//  What Bloomy says on the welcome screen: a short, friendly hello.
//

import Foundation
import Observation

@MainActor
@Observable
final class WelcomeViewModel {
    // Add more lines here to vary the hello.
    static let greetings = [
        "Hi, I'm Bloomy! I'm so happy you're back. Let's play!",
        "Hello, friend! I'm Bloomy. I missed you! Are you ready to play?",
        "Hi there! It's me, Bloomy. Let's grow some flowers together!",
    ]

    // Chosen once, so a replay repeats what the child just heard.
    private(set) var greeting: String
    private var hasGreeted = false
    @ObservationIgnored private let speaker: Speaking

    // `speaker` is optional and resolved in the body: a default argument of
    // `Speaker.shared` is evaluated outside the main actor.
    init(speaker: Speaking? = nil, greeting: String? = nil) {
        self.speaker = speaker ?? Speaker.shared
        self.greeting = greeting ?? Self.greetings.randomElement() ?? Self.greetings[0]
    }

    /// Autoplay when the screen appears; only the first time.
    func greetOnFirstAppear() {
        guard !hasGreeted else { return }
        hasGreeted = true
        replayGreeting()
    }

    func replayGreeting() {
        speaker.say(greeting)
    }
}
