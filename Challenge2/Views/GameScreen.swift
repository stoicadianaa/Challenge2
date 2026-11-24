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

    @Environment(\.screenSize) private var screen

    var body: some View {
        VStack(spacing: screen.isCompact ? 12 : 24) {
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
        .padding(.horizontal, screen.isCompact ? 16 : 32)
        .padding(.vertical, screen.isCompact ? 8 : 16)
        // On iPad the mascot floats over the empty corner. On an iPhone there is no empty
        // corner, so the content makes room for it: below it (portrait) or beside it (landscape).
        .padding(.bottom, screen.isPhonePortrait ? screen.mascotHeight + 16 : 0)
        .padding(.leading, screen.isPhoneLandscape ? screen.mascotHeight + 24 : 0)
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
