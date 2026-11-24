//
//  ProfileSelectionViewModel.swift
//  Challenge2
//
//  Decides what the "Who's playing?" screen says and when. The view only forwards events.
//

import Foundation
import Observation

@MainActor
@Observable
final class ProfileSelectionViewModel {
    // The title is also the spoken line: the child can't read yet, so Bloomy asks out loud.
    static let question = "Who's playing?"

    private var hasGreeted = false
    @ObservationIgnored private let speaker: Speaking

    // `speaker` is optional and resolved in the body: a default argument of
    // `Speaker.shared` is evaluated outside the main actor.
    init(speaker: Speaking? = nil) {
        self.speaker = speaker ?? Speaker.shared
    }

    /// Autoplay: speaks only the first time the screen appears.
    func greetOnFirstAppear() {
        guard !hasGreeted else { return }
        hasGreeted = true
        replay()
    }

    /// The tappable title.
    func replay() {
        speaker.say(Self.question)
    }
}
