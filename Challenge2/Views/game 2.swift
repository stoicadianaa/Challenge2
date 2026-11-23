import AVFoundation
import SwiftUI
import UIKit

struct LanternOrderingGameView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @State private var roundIndex = 0
    @State private var answers: [Lantern?] = [nil]
    @State private var feedback: Feedback?
    @State private var isCelebrating = false
    @State private var speaker: AVSpeechSynthesizer?

    private let onContinue: (() -> Void)?
    private let ink = Color(red: 0.06, green: 0.12, blue: 0.09)
    private let buttonGreen = Color(red: 0.07, green: 0.55, blue: 0.24)
    private let question = "Which lantern comes next?"

    init(onContinue: (() -> Void)? = nil) {
        self.onContinue = onContinue
    }

    private var round: LanternRound {
        LanternRound.all[roundIndex]
    }

    private var guideMessage: String {
        switch feedback {
        case .correct:
            return "You found the pattern!"
        case .retry:
            return "Good try! Look at the pattern again."
        case nil:
            return round.hint
        }
    }

    private var celebratingMascotName: String {
        let asset = "mascot_genderless_celebrating"
        return UIImage(named: asset) == nil ? "mascot_genderless_happy" : asset
    }

    var body: some View {
        GeometryReader { geometry in
            let padding: CGFloat = geometry.size.width < 500 ? 12 : 32
            let width = max(0, geometry.size.width - padding * 2)
            let height = geometry.size.height

            ScrollView {
                Group {
                    if isCelebrating {
                        celebration(width: width, height: height)
                    } else {
                        puzzle(width: width, height: height)
                    }
                }
                .padding(.horizontal, padding)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, minHeight: height)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .background {
            GeometryReader { geometry in
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .accessibilityHidden(true)
            }
            .ignoresSafeArea()
        }
        .foregroundStyle(ink)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(.hidden, for: .navigationBar)
        .task(id: feedback) { @MainActor in
            guard feedback == .correct, !isCelebrating else { return }

            do {
                try await Task.sleep(nanoseconds: 1_200_000_000)
            } catch {
                return
            }

            guard !Task.isCancelled, feedback == .correct else { return }
            advance()
        }
        .onDisappear {
            speaker?.stopSpeaking(at: .immediate)
        }
    }

    private func puzzle(width: CGFloat, height: CGFloat) -> some View {
        let gap: CGFloat = width < 500 ? 5 : 12
        let tileWidth = max(32, min(110, (width - gap * 5) / 6))
        let tileHeight = max(44, min(tileWidth * 1.08, height * 0.18))
        let choiceGap: CGFloat = width < 500 ? 12 : 22
        let choiceWidth = max(44, min(166, (width - choiceGap * 2) / 3, width * 0.17))
        let choiceHeight = max(48, min(choiceWidth * 1.06, height * 0.24))
        let spacing = max(14, min(32, height * 0.043))

        return VStack(spacing: spacing) {
            questionPill
                .padding(.top, max(0, height * 0.018))

            VStack(spacing: 8) {
                Text("\(roundIndex + 1)/\(LanternRound.all.count)")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold).monospacedDigit())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background { LanternGlass(shape: Capsule()) }
                    .frame(maxWidth: tileWidth * 6 + gap * 5, alignment: .leading)
                    .accessibilityLabel("Round \(roundIndex + 1) of \(LanternRound.all.count)")

                patternRow(tileWidth: tileWidth, tileHeight: tileHeight, gap: gap)
            }

            choicesRow(width: choiceWidth, height: choiceHeight, gap: choiceGap)
            puzzleFooter(width: width, height: height)
        }
    }

    private var questionPill: some View {
        Button {
            speak(question)
        } label: {
            Label {
                Text(question)
                    .multilineTextAlignment(.center)
            } icon: {
                Image(systemName: "speaker.wave.2.fill")
            }
            .font(.system(.title, design: .rounded).bold())
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .frame(minHeight: 44)
            .background { LanternGlass(shape: Capsule()) }
        }
        .buttonStyle(.plain)
        .accessibilityHint("Reads the question aloud")
    }

    private func patternRow(
        tileWidth: CGFloat,
        tileHeight: CGFloat,
        gap: CGFloat
    ) -> some View {
        HStack(spacing: gap) {
            ForEach(round.shown.indices, id: \.self) { index in
                let lantern = round.shown[index]

                tile(lantern, width: tileWidth, height: tileHeight)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Position \(index + 1), \(lantern.title)")
            }

            ForEach(answers.indices, id: \.self) { index in
                let answer = answers[index]

                Button {
                    answers[index] = nil
                    feedback = nil
                } label: {
                    tile(answer, width: tileWidth, height: tileHeight)
                }
                .buttonStyle(.plain)
                .disabled(answer == nil || feedback == .correct)
                .accessibilityLabel(
                    "Position \(round.shown.count + index + 1), \(answer?.title ?? "empty")"
                )
                .accessibilityHint(
                    Text(answer == nil ? "Choose a lantern below" : "Removes this lantern")
                )
            }
        }
    }

    private func choicesRow(width: CGFloat, height: CGFloat, gap: CGFloat) -> some View {
        HStack(spacing: gap) {
            ForEach(Lantern.choices) { lantern in
                Button {
                    place(lantern)
                } label: {
                    tile(lantern, width: width, height: height)
                }
                .buttonStyle(.plain)
                .disabled(!answers.contains(nil) || feedback == .correct)
                .accessibilityLabel(Text(lantern.title))
                .accessibilityHint("Fills the first empty position")
            }
        }
    }

    @ViewBuilder
    private func puzzleFooter(width: CGFloat, height: CGFloat) -> some View {
        if width >= 710 && !dynamicTypeSize.isAccessibilitySize {
            let guideWidth = min(224, width * 0.24)

            HStack(spacing: 14) {
                Color.clear
                    .frame(width: guideWidth, height: 1)
                    .accessibilityHidden(true)

                checkButton
                    .frame(maxWidth: .infinity)

                bloomyGuide(width: guideWidth, height: height)
            }
        } else {
            VStack(spacing: 14) {
                checkButton

                bloomyGuide(width: min(224, width), height: height)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }

    private var checkButton: some View {
        actionButton(
            "Check",
            enabled: feedback != .correct && !answers.contains(nil)
        ) {
            checkAnswers()
        }
    }

    private func bloomyGuide(width: CGFloat, height: CGFloat) -> some View {
        let mascotSize = min(160, max(72, height * 0.22))
        let isHappy = feedback == .correct
        let mascotName = isHappy ? celebratingMascotName : "mascot_genderless_happy"

        return VStack(alignment: .trailing, spacing: 4) {
            Button {
                speak(guideMessage)
            } label: {
                Text(guideMessage)
                    .font(.system(.callout, design: .rounded).weight(.semibold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background {
                        LanternGlass(shape: RoundedRectangle(cornerRadius: 18))
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Path { path in
                            path.move(to: .zero)
                            path.addLine(to: CGPoint(x: 18, y: 0))
                            path.addLine(to: CGPoint(x: 13, y: 9))
                            path.closeSubpath()
                        }
                        .fill(Color(red: 0.86, green: 0.98, blue: 0.75).opacity(0.90))
                        .frame(width: 18, height: 9)
                        .padding(.trailing, mascotSize * 0.28)
                        .offset(y: 8)
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text("Bloomy says: \(guideMessage)"))
            .accessibilityHint("Reads Bloomy’s message aloud")

            Image(mascotName)
                .resizable()
                .scaledToFit()
                .frame(width: mascotSize, height: mascotSize)
                .overlay(alignment: .topLeading) {
                    if isHappy {
                        Image(systemName: "sparkles")
                            .font(.system(size: mascotSize * 0.23, weight: .bold))
                            .foregroundStyle(.yellow)
                            .shadow(color: .orange.opacity(0.55), radius: 3)
                    }
                }
                .accessibilityHidden(true)
        }
        .frame(width: width)
    }

    private func tile(_ lantern: Lantern?, width: CGFloat, height: CGFloat) -> some View {
        let shape = RoundedRectangle(cornerRadius: min(24, width * 0.15))

        return ZStack {
            LanternGlass(shape: shape)

            if let lantern {
                LanternArtwork(lantern: lantern)
                    .frame(width: width * 0.78, height: height * 0.79)
            } else {
                RoundedRectangle(cornerRadius: 13)
                    .strokeBorder(
                        ink.opacity(0.56),
                        style: StrokeStyle(lineWidth: 2, dash: [6, 5])
                    )
                    .padding(7)

                Image(systemName: "questionmark")
                    .font(.system(size: min(width, height) * 0.36, weight: .bold, design: .rounded))
                    .accessibilityHidden(true)
            }
        }
        .frame(width: width, height: height)
        .contentShape(shape)
    }

    private func actionButton(
        _ title: LocalizedStringKey,
        enabled: Bool = true,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(.title2, design: .rounded).bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 9)
                .frame(minWidth: 96, minHeight: 50)
                .background {
                    Capsule()
                        .fill(buttonGreen)
                        .overlay {
                            Capsule().strokeBorder(.white.opacity(0.24), lineWidth: 1)
                        }
                }
                .opacity(enabled ? 1 : 0.65)
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }

    private func celebration(width: CGFloat, height: CGFloat) -> some View {
        let artworkSize = min(103, width * 0.135)
        let cordWidth = (artworkSize + 4) * 3

        return VStack(spacing: max(18, height * 0.065)) {
            HStack(spacing: min(24, width * 0.025)) {
                Image(celebratingMascotName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(290, width * 0.32), height: min(340, height * 0.51))
                    .accessibilityLabel("Bloomy")

                VStack(spacing: 4) {
                    Text("You lit my lanterns!")
                        .font(.system(.largeTitle, design: .rounded).bold())
                        .multilineTextAlignment(.center)
                        .accessibilityAddTraits(.isHeader)

                    HStack(alignment: .top, spacing: 4) {
                        ForEach(round.solution.indices, id: \.self) { index in
                            LanternArtwork(lantern: round.solution[index], glowing: true)
                                .frame(width: artworkSize, height: artworkSize * 1.2)
                                .padding(.top, index == 1 ? 14 : 4)
                        }
                    }
                    .padding(.top, 10)
                    .background(alignment: .top) {
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 10))
                            path.addQuadCurve(
                                to: CGPoint(x: cordWidth, y: 10),
                                control: CGPoint(x: cordWidth / 2, y: 37)
                            )
                        }
                        .stroke(Color(red: 0.38, green: 0.22, blue: 0.07), lineWidth: 4)
                        .frame(width: cordWidth, height: 32)
                    }
                    .accessibilityHidden(true)
                }
                .padding(min(24, width * 0.043))
                .background {
                    LanternGlass(shape: RoundedRectangle(cornerRadius: 26))
                }
            }

            actionButton("Continue") {
                if let onContinue {
                    onContinue()
                } else {
                    dismiss()
                }
            }
        }
    }

    private func place(_ lantern: Lantern) {
        guard feedback != .correct,
              let index = answers.firstIndex(of: nil) else { return }

        answers[index] = lantern
        feedback = nil
    }

    private func checkAnswers() {
        guard feedback != .correct, !answers.contains(nil) else { return }

        if answers == round.solution.map({ Optional($0) }) {
            feedback = .correct
        } else {
            for index in answers.indices where answers[index] != round.solution[index] {
                answers[index] = nil
            }
            feedback = .retry
        }

        UIAccessibility.post(notification: .announcement, argument: guideMessage)
    }

    private func advance() {
        guard roundIndex + 1 < LanternRound.all.count else {
            isCelebrating = true
            UIAccessibility.post(notification: .announcement, argument: "You lit my lanterns!")
            return
        }

        roundIndex += 1
        answers = Array(repeating: nil, count: round.solution.count)
        feedback = nil

        UIAccessibility.post(
            notification: .announcement,
            argument: "Round \(roundIndex + 1). \(question)"
        )
    }

    private func speak(_ message: String) {
        let synthesizer = speaker ?? AVSpeechSynthesizer()
        speaker = synthesizer
        synthesizer.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.43
        synthesizer.speak(utterance)
    }

    private enum Feedback: Equatable {
        case correct
        case retry
    }
}

private struct LanternGlass<Surface: InsettableShape>: View {
    let shape: Surface

    var body: some View {
        shape
            .fill(.ultraThinMaterial)
            .overlay {
                shape.fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.62, green: 0.97, blue: 0.98).opacity(0.46),
                            Color(red: 0.84, green: 1, blue: 0.65).opacity(0.30)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .overlay {
                shape.strokeBorder(.white.opacity(0.45), lineWidth: 1)
            }
            .environment(\.colorScheme, .light)
            .shadow(color: .black.opacity(0.10), radius: 5, y: 2)
            .accessibilityHidden(true)
    }
}

private struct LanternRound {
    let shown: [Lantern]
    let solution: [Lantern]
    let hint: String

    static let all: [Self] = [
        .init(
            shown: [.leaf, .acorn, .leaf, .acorn, .leaf],
            solution: [.acorn],
            hint: "A leaf, then an acorn. What comes after the leaf?"
        ),
        .init(
            shown: [.leaf, .acorn, .leaf, .acorn],
            solution: [.leaf, .acorn],
            hint: "Two spaces to fill. Start with the first one."
        ),
        .init(
            shown: [.leaf, .acorn, .flower],
            solution: [.leaf, .acorn, .flower],
            hint: "Find the group of three and repeat it."
        )
    ]
}

private enum Lantern: String, Identifiable {
    case leaf
    case acorn
    case flower

    static let choices: [Self] = [.flower, .leaf, .acorn]

    var id: Self { self }
    var assetName: String { "lantern_\(rawValue)" }
    var title: String { "\(rawValue.capitalized) lantern" }
}

private struct LanternArtwork: View {
    let lantern: Lantern
    var glowing = false

    private let brown = Color(red: 0.39, green: 0.22, blue: 0.09)
    private let gold = Color(red: 1, green: 0.76, blue: 0.20)

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height * 0.81)

            Group {
                if lantern == .leaf {
                    GardenLeafLantern()
                        .frame(width: size, height: size * 1.16)
                } else if let artwork = UIImage(named: lantern.assetName) {
                    Image(uiImage: artwork)
                        .resizable()
                        .scaledToFit()
                } else {
                    VStack(spacing: -size * 0.06) {
                        Ellipse()
                            .strokeBorder(brown, lineWidth: max(2, size * 0.037))
                            .frame(width: size * 0.16, height: size * 0.22)

                        switch lantern {
                        case .leaf:
                            EmptyView()
                        case .acorn:
                            acorn(size: size)
                        case .flower:
                            flower(size: size)
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .shadow(color: glowing ? .yellow.opacity(0.9) : .clear, radius: size * 0.16)
        }
        .accessibilityHidden(true)
    }

    private func acorn(size: CGFloat) -> some View {
        ZStack(alignment: .top) {
            Capsule()
                .fill(
                    RadialGradient(
                        colors: [.yellow, gold, .orange],
                        center: .center,
                        startRadius: 1,
                        endRadius: size * 0.48
                    )
                )
                .overlay {
                    Capsule().strokeBorder(brown, lineWidth: size * 0.04)
                }
                .frame(width: size * 0.63, height: size * 0.72)
                .offset(y: size * 0.17)

            Ellipse()
                .fill(Color(red: 0.77, green: 0.43, blue: 0.15))
                .overlay {
                    Ellipse().strokeBorder(brown, lineWidth: size * 0.05)
                }
                .frame(width: size * 0.8, height: size * 0.35)
                .overlay {
                    Image(systemName: "diamond")
                        .font(.system(size: size * 0.15, weight: .semibold))
                        .foregroundStyle(brown)
                }
        }
        .frame(width: size, height: size, alignment: .top)
    }

    private func flower(size: CGFloat) -> some View {
        ZStack {
            ForEach(0..<5) { petal in
                Capsule()
                    .fill(Color(red: 0.33, green: 0.56, blue: 0.95).gradient)
                    .overlay {
                        Capsule().strokeBorder(Color.blue.opacity(0.8), lineWidth: size * 0.025)
                    }
                    .frame(width: size * 0.36, height: size * 0.5)
                    .offset(y: -size * 0.26)
                    .rotationEffect(.degrees(Double(petal) * 72))
            }

            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white, .yellow, gold],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.2
                    )
                )
                .frame(width: size * 0.33)
        }
        .frame(width: size, height: size)
    }
}

private struct GardenLeafLantern: View {
    private let outline = Color(red: 0.32, green: 0.25, blue: 0.10)
    private let vein = Color(red: 0.28, green: 0.43, blue: 0.12)

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let lineWidth = max(1.3, width * 0.026)
            let leaf = leafPath(width: width, height: height)

            ZStack {
                Ellipse()
                    .strokeBorder(outline, lineWidth: lineWidth)
                    .frame(width: width * 0.16, height: height * 0.19)
                    .position(x: width * 0.51, y: height * 0.14)

                leaf.fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.95, green: 0.98, blue: 0.55),
                            Color(red: 0.69, green: 0.85, blue: 0.31),
                            Color(red: 0.39, green: 0.62, blue: 0.20)
                        ],
                        center: UnitPoint(x: 0.38, y: 0.41),
                        startRadius: width * 0.06,
                        endRadius: width * 0.61
                    )
                )
                leaf.stroke(outline, style: StrokeStyle(lineWidth: lineWidth, lineJoin: .round))

                leafVeins(width: width, height: height)
                    .stroke(vein, style: StrokeStyle(lineWidth: lineWidth * 0.74, lineCap: .round))
            }
            .frame(width: width, height: height)
        }
    }

    private func leafPath(width: CGFloat, height: CGFloat) -> Path {
        Path { path in
            path.move(to: point(0.51, 0.19, width, height))
            path.addQuadCurve(
                to: point(0.89, 0.45, width, height),
                control: point(0.86, 0.13, width, height)
            )
            path.addCurve(
                to: point(0.48, 0.94, width, height),
                control1: point(0.94, 0.67, width, height),
                control2: point(0.68, 0.81, width, height)
            )
            path.addCurve(
                to: point(0.12, 0.43, width, height),
                control1: point(0.23, 0.81, width, height),
                control2: point(0.07, 0.67, width, height)
            )
            path.addQuadCurve(
                to: point(0.51, 0.19, width, height),
                control: point(0.17, 0.21, width, height)
            )
            path.closeSubpath()
        }
    }

    private func leafVeins(width: CGFloat, height: CGFloat) -> Path {
        Path { path in
            path.move(to: point(0.53, 0.28, width, height))
            path.addQuadCurve(
                to: point(0.48, 0.85, width, height),
                control: point(0.55, 0.57, width, height)
            )

            path.move(to: point(0.53, 0.50, width, height))
            path.addQuadCurve(
                to: point(0.28, 0.41, width, height),
                control: point(0.42, 0.48, width, height)
            )

            path.move(to: point(0.52, 0.56, width, height))
            path.addQuadCurve(
                to: point(0.75, 0.42, width, height),
                control: point(0.65, 0.51, width, height)
            )

            path.move(to: point(0.50, 0.71, width, height))
            path.addQuadCurve(
                to: point(0.30, 0.61, width, height),
                control: point(0.40, 0.68, width, height)
            )

            path.move(to: point(0.49, 0.77, width, height))
            path.addQuadCurve(
                to: point(0.70, 0.64, width, height),
                control: point(0.59, 0.73, width, height)
            )
        }
    }

    private func point(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGPoint {
        CGPoint(x: x * width, y: y * height)
    }
}

struct LanternOrderingGameView_Previews: PreviewProvider {
    static var previews: some View {
        LanternOrderingGameView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
