import SwiftUI

struct WelcomeView: View {
    var onStart: () -> Void = {}
    
    @State private var floating = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showBubble = false

    var body: some View {
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

                Button(action: onStart) {
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
    }
}

#Preview() {
    WelcomeView()
}
