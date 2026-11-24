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
    // Add more lines here to vary what is said. Keep them short: the child can't
    // read yet, so the picture cards do the explaining. The hello itself belongs
    // to WelcomeViewModel.
    static let greetings = [
        "Pick a game, friend!",
        "Tap a picture to play!",
        "Which game looks fun?",
        "\(GameType.spokenList)? You choose!",
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

    /// The tappable title on the home screen.
    func replayGreeting() {
        speaker.say(greeting)
    }
}
