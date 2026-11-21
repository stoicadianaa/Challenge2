//
//  RewardScreen.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 19/11/2026.
//

import SwiftUI

struct SpeechBubble: Shape {
    static let tailSize: CGFloat = 16
    var tailAtTop: Bool

    func path(in rect: CGRect) -> Path {
        let tail = Self.tailSize

        // The bubble body is the rect minus the strip reserved for the tail.
        var body = rect
        if tailAtTop {
            body.origin.y += tail
            body.size.height -= tail
        } else {
            body.origin.x += tail
            body.size.width -= tail
        }

        var path = Path(roundedRect: body, cornerRadius: 20)

        // The tail: a triangle on the body's edge, tip pointing outward.
        var triangle = Path()
        if tailAtTop {
            triangle.move(to: CGPoint(x: rect.midX - tail, y: body.minY))
            triangle.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            triangle.addLine(to: CGPoint(x: rect.midX + tail, y: body.minY))
        } else {
            triangle.move(to: CGPoint(x: body.minX, y: rect.midY - tail))
            triangle.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            triangle.addLine(to: CGPoint(x: body.minX, y: rect.midY + tail))
        }
        triangle.closeSubpath()

        path.addPath(triangle)
        return path
    }
}

struct RewardScreen: View {
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
                    Text("+1")
                }
                .font(.system(size: heroSize, weight: .heavy, design: .rounded))
            }
            .padding(32)
            .padding(isStacked ? .top : .leading, SpeechBubble.tailSize)
            .background(.regularMaterial, in: SpeechBubble(tailAtTop: isStacked))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(message) You earned one water drop.")
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
