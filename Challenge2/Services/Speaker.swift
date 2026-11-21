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

    // Tuning knobs for how the voice sounds. Change these while listening in
    // the simulator. Pitch near the 2.0 maximum sounds thin and robotic.
    private enum Tuning {
        static let rate = AVSpeechUtteranceDefaultSpeechRate * 0.9  // slightly slower for kids
        static let pitch: Float = 1.2  // 1.0 is natural; a little higher sounds friendly
        static let pauseBefore: TimeInterval = 0.1  // avoids a clipped first syllable
    }

    // The phrase being spoken right now (nil when silent). Asking for the same
    // phrase again, e.g. autoplay followed by a button tap, is ignored.
    private var speakingText: String?
    private var currentUtterance: AVSpeechUtterance?
    private let delegate = SpeechDelegate()

    private init() {
        synthesizer.delegate = delegate
        delegate.onEnd = { [weak self] id in self?.speechEnded(id) }
    }

    func say(_ text: String) {
        // Already saying exactly this: let it finish instead of restarting or repeating it.
        guard text != speakingText else { return }

        // A different phrase replaces the current one rather than queueing behind it.
        synthesizer.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = bestVoice()
        utterance.rate = Tuning.rate
        utterance.pitchMultiplier = Tuning.pitch
        utterance.preUtteranceDelay = Tuning.pauseBefore
        speakingText = text
        currentUtterance = utterance
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        speakingText = nil
        currentUtterance = nil
    }

    // Called when an utterance finishes or is cancelled. A cancelled *old* utterance
    // reports in after the new one has started, so only the current one may clear the state.
    private func speechEnded(_ id: ObjectIdentifier) {
        guard let current = currentUtterance, ObjectIdentifier(current) == id else { return }
        speakingText = nil
        currentUtterance = nil
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
        if let best { return best }

        // Only standard voices installed: prefer Samantha, the warmest of them,
        // over whatever the system happens to pick for en-US.
        let samantha = AVSpeechSynthesisVoice.speechVoices().first {
            $0.language == "en-US" && $0.name.hasPrefix("Samantha")
        }
        return samantha ?? AVSpeechSynthesisVoice(language: "en-US")
    }
}

/// Reports when speech ends. A separate NSObject because `Speaker` isn't one,
/// and the delegate callbacks arrive off the main actor.
private final class SpeechDelegate: NSObject, AVSpeechSynthesizerDelegate {
    @MainActor var onEnd: ((ObjectIdentifier) -> Void)?

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        report(utterance)
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        report(utterance)
    }

    private nonisolated func report(_ utterance: AVSpeechUtterance) {
        let id = ObjectIdentifier(utterance)
        Task { @MainActor in onEnd?(id) }
    }
}
