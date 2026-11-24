//
//  MascotView.swift
//  Challenge2
//
//  The mascot with its speech bubble. It only draws what it is given:
//  the game decides which mascot to show, what the bubble says and what a tap does.
//

import SwiftUI

struct MascotView: View {
    /// The one size used on every game screen.
    static let standardHeight: CGFloat = 200

    let mascot: Mascot
    var message: String?  // nil hides the bubble
    var height: CGFloat = MascotView.standardHeight
    let onTap: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            Button(action: onTap) {
                Image(mascot.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: height)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Mascot")
            .accessibilityHint("Tap for some encouragement")

            if let message {
                SpeechBubble(text: message)
                    .padding(.top, 20)
                    .transition(
                        .scale(scale: 0.8, anchor: .bottomLeading)
                            .combined(with: .opacity)
                    )
                    .allowsHitTesting(false)  // the bubble never blocks the game underneath
            }
        }
        .padding(16)
        .animation(.spring, value: message)
    }
}

extension View {
    /// Puts the coach's mascot in the one place every game screen uses: bottom-left, same size.
    func mascotOverlay(_ coach: MascotCoach) -> some View {
        overlay(alignment: .bottomLeading) {
            MascotView(mascot: coach.mascot, message: coach.line) {
                coach.encourage()
            }
        }
    }
}

#Preview {
    MascotView(mascot: .neutral, message: "You can do it!") {}
}
