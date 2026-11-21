//
//  RewardScreen.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 19/11/2026.
//

import SwiftUI

struct RewardScreen: View {
    // How many water drops this session earned; shown as "+N".
    var drops = 1
    var onContinue: () -> Void = {}

    private static let phrases = ["Yay!", "Hooray!", "Wow!", "You did it!", "Yippee!"]
    @State private var message = RewardScreen.phrases.randomElement() ?? "Yay!"
    
    @State private var appeared = false

    @ScaledMetric(relativeTo: .largeTitle) private var heroSize: CGFloat = 72

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private var isStacked: Bool {
        horizontalSizeClass == .compact && verticalSizeClass == .regular
    }

    private func speak() {
        guard !voiceOverEnabled else { return }

        Speaker.shared.say(message)
    }

    func mascot(axis: Axis.Set, fraction: CGFloat) -> some View {
        Image(decorative: "mascot_genderless_celebrating")
            .resizable()
            .scaledToFit()
            .containerRelativeFrame(axis) { length, _ in length * fraction }
    }

    var rewardCard: some View {
        Button(action: speak) {
            // The same bubble as the welcome screen, with the reward as its content.
            SpeechBubble {
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .symbolEffect(.bounce, value: appeared)
                            .accessibilityHidden(true)
                        Text(message)
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .symbolEffect(.bounce, value: appeared)
                            .accessibilityHidden(true)
                    }
                    .font(.title.weight(.semibold))

                    HStack {
                        Image(systemName: "drop.fill")
                            .foregroundStyle(.blue)
                            .symbolEffect(.bounce, value: appeared)
                        Text("+\(drops)")
                    }
                    .font(.system(size: heroSize, weight: .heavy, design: .rounded))
                }
                .padding(.vertical, 16)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(message) You earned \(drops) water \(drops == 1 ? "drop" : "drops").")
        .accessibilityHint("Plays the message again")
        .scaleEffect(appeared || reduceMotion ? 1 : 0.8)
        .opacity(appeared ? 1 : 0)
    }

    var body: some View {
        VStack {
            Spacer()

            if isStacked {
                mascot(axis: .horizontal, fraction: 0.5)
                rewardCard
            } else {
                HStack {
                    mascot(axis: .vertical, fraction: 0.5)
                    rewardCard
                }
            }

            Spacer()

            Button(action: onContinue) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .controlSize(.extraLarge)
            .tint(.green)
            .font(.title.bold())
            .frame(maxWidth: 400)
            // Side margin so it never touches the screen edges on a small iPhone.
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onAppear {
            withAnimation(reduceMotion ? .easeIn : .bouncy) {
                appeared = true
            }
            speak()
        }
        .sensoryFeedback(.success, trigger: appeared)
        .fontDesign(.rounded)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    RewardScreen()
}

#Preview("Large text") {
    RewardScreen()
        .dynamicTypeSize(.accessibility3)
}

#Preview("Landscape", traits: .landscapeLeft) {
    RewardScreen()
}
