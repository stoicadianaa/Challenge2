//
//  InstructionButton.swift
//  Challenge2
//
//  The title of a game: shows the instruction and reads it aloud when tapped.
//  Every game uses this, so the look and the speaking behave the same everywhere.
//

import SwiftUI

struct InstructionButton: View {
    let text: String
    let speak: () -> Void

    /// The usual case: read `text` aloud through the game's mascot.
    init(text: String, coach: MascotCoach) {
        self.init(text: text) { coach.speakInstruction(text) }
    }

    /// For screens that decide what is spoken themselves (e.g. the home greeting).
    init(text: String, speak: @escaping () -> Void) {
        self.text = text
        self.speak = speak
    }

    var body: some View {
        Button(action: speak) {
            Label(text, systemImage: "speaker.wave.2.fill")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .multilineTextAlignment(.center)
        }
        .buttonStyle(.glass)
        .controlSize(.extraLarge)
        .accessibilityHint("Reads the instruction aloud")
    }
}

#Preview {
    InstructionButton(text: "Find the correct word!", coach: MascotCoach())
}
