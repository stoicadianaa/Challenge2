//
//  LanternArtwork.swift
//
//  The drawing of one lantern (leaf, acorn or flower). Uses the image
//  "lantern_<name>" from the asset catalog when there is one, otherwise draws it.
//

import SwiftUI
import UIKit

struct LanternArtwork: View {
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
