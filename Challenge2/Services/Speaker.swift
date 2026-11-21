//
//  Speaker.swift
//  Challenge2
//
//  Speaks short phrases aloud using the device's built-in voices,
//  preferring Enhanced/Premium voices when the user has downloaded them.
//

import AVFoundation

/// Anything that can speak a phrase. View models depend on this instead of
/// `Speaker`, so tests can pass a fake that makes no sound.
@MainActor
protocol Speaking {
    func say(_ text: String)
}

@MainActor
final class Speaker: Speaking {
    static let shared = Speaker()

    // Kept for the lifetime of the app; a local synthesizer would be
    // deallocated mid-sentence.
    private let synthesizer = AVSpeechSynthesizer()

    private init() {}

    func say(_ text: String) {
        // Don't queue sentences when the child taps quickly.
        synthesizer.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = bestVoice()
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.85  // a bit slower for kids
        utterance.pitchMultiplier = 1.6
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    // Highest-quality English voice installed (Premium > Enhanced). Falls back to the
    // system's standard en-US voice rather than risking a novelty voice.
    // Computed on every call so a voice downloaded while the app runs is picked up.
    private func bestVoice() -> AVSpeechSynthesisVoice? {
        let better = AVSpeechSynthesisVoice.speechVoices().filter {
            $0.language.hasPrefix("en") && $0.quality != .default
        }
        let best = better.max {
            ($0.quality.rawValue, $0.language == "en-US" ? 1 : 0)
                < ($1.quality.rawValue, $1.language == "en-US" ? 1 : 0)
        }
        return best ?? AVSpeechSynthesisVoice(language: "en-US")
    }
}
