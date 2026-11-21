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
        // Short sentences with commas: the synthesizer follows punctuation for its pauses.
        "Hi there, friend! I'm Bloomy. Welcome to WonderBloom! Let's pick a game together. We can try, \(GameType.spokenList).",
        "Hi, friend! Let's help our garden grow. Which game should we try first?",
        "Yay, you're back! Let's grow some flowers today. Pick any game you like!",
        "Hello, hello! I'm so happy to see you. Tap a picture, and let's have some fun!",
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
