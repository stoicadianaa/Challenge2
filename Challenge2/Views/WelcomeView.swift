import SwiftUI

struct WelcomeView: View {
    // Start moves on to the home screen; the app itself doesn't need to know.
    @State private var hasStarted = false

    @State private var floating = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showBubble = false

    @State private var viewModel = WelcomeViewModel()
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled

    var body: some View {
        if hasStarted {
            HomeView()
        } else {
            welcome
        }
    }

    private var welcome: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .accessibilityHidden(true)

            VStack(spacing: 32) {
                WelcomeLogo(fontSize: 60)

                ZStack(alignment: .topTrailing) {

                    Image("mascot_genderless_celebrating")
                        .resizable()
                        .scaledToFit()
                        .containerRelativeFrame(.vertical) { height, _ in height * 0.44 }
                        .offset(y: floating ? -12 : 12)
                        .rotationEffect(.degrees(floating ? 2 : -2))
                        .animation(
                            reduceMotion ? nil :
                                .easeInOut(duration: 1.4).repeatForever(autoreverses: true),
                            value: floating
                        )
                        .accessibilityHidden(true)

                    SpeechBubble(text: "Welcome!")
                        .offset(x: 150, y: -20)
                        .scaleEffect(showBubble ? 1 : 0.2, anchor: .bottomLeading)
                        .opacity(showBubble ? 1 : 0)
                        .animation(
                            reduceMotion ? nil : .spring(response: 0.5, dampingFraction: 0.55),
                            value: showBubble
                        )
                }
                .onAppear {
                    if !reduceMotion { floating = true }
                    // The bubble pops up after the title has finished appearing
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        showBubble = true
                    }
                }

                Button {
                    withAnimation { hasStarted = true }
                } label: {
                    Label("Start", systemImage: "play.fill")
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.glassProminent)
                .tint(.green)
                .controlSize(.extraLarge)
            }
        }
        .onAppear {
            // VoiceOver already reads the screen, so the spoken hello would talk over it.
            guard !voiceOverEnabled else { return }
            viewModel.greetOnFirstAppear()
        }
    }
}

#Preview() {
    WelcomeView()
}
