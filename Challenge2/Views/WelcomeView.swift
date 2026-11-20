import SwiftUI
import UIKit

struct WelcomeView: View {
    var onStart: () -> Void = {}

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let centerX = width * 0.527

            let adaptation = min(
                max((height / max(width, 1) - 0.4025) / 0.3475, 0),
                1
            )

            let logoWidth = min(width * 0.57, height * 1.42)
            let buttonWidth = min(width * 0.38, height * 0.655)
            let buttonHeight = buttonWidth * 0.26

            let buttonY = min(
                height * (0.888 - 0.065 * adaptation),
                height
                    - geometry.safeAreaInsets.bottom
                    - 16
                    - buttonHeight / 2
            )

            let mascotWidth = buttonWidth * 0.85
            let mascotHeight = mascotWidth * 0.78

            let mascotBottom = buttonY
                - buttonHeight / 2
                + buttonHeight * 0.07

            ZStack(alignment: .topLeading) {

                // نام بک‌گراند در کد قبلی پروژه
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
                    .accessibilityHidden(true)

                // نام کاراکتر در کد قبلی پروژه
                Image("mascot_genderless_happy")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: mascotWidth,
                        height: mascotHeight,
                        alignment: .top
                    )
                    .clipped()
                    .position(
                        x: centerX,
                        y: mascotBottom - mascotHeight / 2
                    )
                    .accessibilityHidden(true)

                WelcomeWoodenLogo(width: logoWidth)
                    .position(
                        x: centerX,
                        y: height * 0.235
                    )
                    .accessibilityLabel(Text(verbatim: "WonderBloom"))
                    .accessibilityAddTraits(.isHeader)

                Button(action: onStart) {
                    HStack(spacing: buttonHeight * 0.27) {
                        Image(systemName: "play.fill")
                            .font(
                                .system(
                                    size: buttonHeight * 0.54,
                                    weight: .bold
                                )
                            )

                        Text(verbatim: "Start")
                            .font(
                                .system(
                                    size: buttonHeight * 0.62,
                                    weight: .bold,
                                    design: .rounded
                                )
                            )
                            .lineLimit(1)
                    }
                    .foregroundStyle(.white)
                    .shadow(
                        color: .black.opacity(0.15),
                        radius: 1,
                        y: 2
                    )
                    .frame(
                        width: buttonWidth,
                        height: buttonHeight
                    )
                    .background {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(
                                            red: 0.57,
                                            green: 0.75,
                                            blue: 0.30
                                        ),
                                        Color(
                                            red: 0.34,
                                            green: 0.58,
                                            blue: 0.20
                                        )
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .shadow(
                                color: .black.opacity(0.20),
                                radius: 3,
                                y: 4
                            )
                    }
                    .overlay {
                        Capsule()
                            .strokeBorder(
                                Color(
                                    red: 0.39,
                                    green: 0.57,
                                    blue: 0.23
                                ),
                                lineWidth: buttonHeight * 0.035
                            )
                    }
                    .overlay {
                        Capsule()
                            .inset(by: buttonHeight * 0.045)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.35),
                                        .clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: buttonHeight * 0.018
                            )
                    }
                    .contentShape(Capsule())
                }
                .buttonStyle(WelcomePressStyle())
                .position(
                    x: centerX,
                    y: buttonY
                )
                .accessibilityLabel(Text(verbatim: "Start"))
            }
            .frame(width: width, height: height)
            .clipped()
        }
        .ignoresSafeArea()
        .environment(\.layoutDirection, .leftToRight)
        .preferredColorScheme(.light)
        .statusBarHidden(true)
    }
}

private struct WelcomeWoodenLogo: View {
    let width: CGFloat

    var body: some View {
        Group {
            if let logo = UIImage(named: "welcome_sign") {
                Image(uiImage: logo)
                    .resizable()
                    .scaledToFit()
            } else {
                // اگر اسست تابلو اضافه نشده باشد، عنوان خالی نمی‌ماند.
                ZStack {
                    RoundedRectangle(
                        cornerRadius: width * 0.055
                    )
                    .fill(
                        Color(
                            red: 0.55,
                            green: 0.28,
                            blue: 0.08
                        )
                    )
                    .frame(
                        width: width * 0.93,
                        height: width * 0.19
                    )
                    .rotationEffect(.degrees(-3))
                    .offset(y: width * 0.025)

                    ForEach(0..<4) { index in
                        WelcomeLeaf()
                            .fill(
                                index.isMultiple(of: 2)
                                    ? Color(
                                        red: 0.47,
                                        green: 0.66,
                                        blue: 0.15
                                    )
                                    : Color(
                                        red: 0.65,
                                        green: 0.74,
                                        blue: 0.20
                                    )
                            )
                            .overlay {
                                WelcomeLeaf()
                                    .stroke(
                                        Color(
                                            red: 0.34,
                                            green: 0.46,
                                            blue: 0.10
                                        ),
                                        lineWidth: 2
                                    )
                            }
                            .frame(
                                width: width * 0.075,
                                height: width * 0.045
                            )
                            .rotationEffect(
                                .degrees(index < 2 ? -30 : 210)
                            )
                            .position(
                                x: index < 2
                                    ? width * 0.065
                                    : width * 0.935,
                                y: index.isMultiple(of: 2)
                                    ? width * 0.075
                                    : width * 0.17
                            )
                    }

                    RoundedRectangle(
                        cornerRadius: width * 0.05
                    )
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(
                                    red: 1,
                                    green: 0.86,
                                    blue: 0.57
                                ),
                                Color(
                                    red: 0.97,
                                    green: 0.72,
                                    blue: 0.36
                                )
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay {
                        RoundedRectangle(
                            cornerRadius: width * 0.05
                        )
                        .strokeBorder(
                            Color(
                                red: 0.71,
                                green: 0.43,
                                blue: 0.17
                            ),
                            lineWidth: width * 0.007
                        )
                    }
                    .frame(
                        width: width * 0.86,
                        height: width * 0.205
                    )
                    .shadow(
                        color: .black.opacity(0.15),
                        radius: 2,
                        y: 3
                    )

                    Text(verbatim: "WonderBloom")
                        .font(
                            .custom(
                                "ChalkboardSE-Bold",
                                size: width * 0.105
                            )
                        )
                        .foregroundStyle(
                            Color(
                                red: 0.37,
                                green: 0.18,
                                blue: 0.045
                            )
                        )
                        .shadow(
                            color: .white.opacity(0.45),
                            radius: 0,
                            y: 1
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .frame(width: width * 0.79)
                }
            }
        }
        .frame(
            width: width,
            height: width * 0.29
        )
    }
}

private struct WelcomeLeaf: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(
            to: CGPoint(
                x: rect.minX,
                y: rect.maxY
            )
        )

        path.addQuadCurve(
            to: CGPoint(
                x: rect.maxX,
                y: rect.minY
            ),
            control: CGPoint(
                x: rect.minX,
                y: rect.minY
            )
        )

        path.addQuadCurve(
            to: CGPoint(
                x: rect.minX,
                y: rect.maxY
            ),
            control: CGPoint(
                x: rect.maxX,
                y: rect.maxY
            )
        )

        path.closeSubpath()
        return path
    }
}

private struct WelcomePressStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(
                configuration.isPressed && !reduceMotion ? 0.97 : 1
            )
            .brightness(
                configuration.isPressed ? -0.035 : 0
            )
            .animation(
                reduceMotion ? nil : .easeOut(duration: 0.12),
                value: configuration.isPressed
            )
    }
}

#Preview(
    "iPad Landscape",
    traits: .fixedLayout(width: 1194, height: 834)
) {
    WelcomeView()
}
