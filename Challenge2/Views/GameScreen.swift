//
//  GameScreen.swift
//  Challenge2
//
//  The layout every game shares: the spoken title, the main interactive element
//  big in the middle, and the action (Check, answers, colours) below it.
//  The background and the mascot come with it, so the games only supply content.
//

import SwiftUI

struct GameScreen<Content: View, Footer: View>: View {
    let title: String
    let coach: MascotCoach
    // true: the content takes all the room between title and footer (e.g. a drawing canvas).
    // false: title, content and footer sit evenly spread, like the ordering screen.
    var expandsContent = false
    @ViewBuilder var content: Content
    @ViewBuilder var footer: Footer

    var body: some View {
        VStack(spacing: 24) {
            if expandsContent {
                InstructionButton(text: title, coach: coach)
                content.frame(maxWidth: .infinity, maxHeight: .infinity)
                footer
            } else {
                Spacer()
                InstructionButton(text: title, coach: coach)
                Spacer()
                content
                Spacer()
                footer
                Spacer()
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fontDesign(.rounded)
        .background {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .accessibilityHidden(true)
        }
        // The mascot floats above the game; its bubble may cover the content
        .mascotOverlay(coach)
    }
}
