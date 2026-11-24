//
//  OddOneOutTile.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import SwiftUI

struct OddOneOutTile: View {
    let emoji: String
    let tint: Color
    let isOdd: Bool
    let isSolved: Bool
    let isWrong: Bool
    let shakes: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(emoji)
                .padding(24)
                .glassEffect(.regular.tint(tint.opacity(0.4)), in: .rect(cornerRadius: 32))
        }
        //.buttonStyle(ScaleButtonStyle())
        .disabled(isSolved || isWrong)
        .overlay { cross }
        .opacity(opacity)
        .scaleEffect(isSolved && isOdd ? 1.08 : 1)
        .modifier(ShakeEffect(animatableData: CGFloat(shakes)))
        .animation(.linear(duration: 0.45), value: shakes)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSolved)
        .animation(.easeOut(duration: 0.25), value: isWrong)
    }

    private var opacity: Double {
        if isWrong { return 0.4 }
        if isSolved && !isOdd { return 0.55 }
        return 1
    }

    @ViewBuilder
    private var cross: some View {
        if isOdd {
            CrossShape(progress: isSolved ? 2 : 0)
                .stroke(.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .padding(-20)                 // a bit bigger than the tile
                .allowsHitTesting(false)
                .animation(.easeOut(duration: 0.7), value: isSolved)
        }
    }
}

private struct CrossShape: Shape {
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height

        var first = Path()
        first.move(to: CGPoint(x: w * 0.04, y: h * 0.02))
        first.addQuadCurve(to: CGPoint(x: w * 0.97, y: h * 0.96),
                           control: CGPoint(x: w * 0.60, y: h * 0.40))

        var second = Path()
        second.move(to: CGPoint(x: w * 0.96, y: h * 0.02))
        second.addQuadCurve(to: CGPoint(x: w * 0.03, y: h * 0.98),
                            control: CGPoint(x: w * 0.35, y: h * 0.45))

        var result = Path()
        result.addPath(first.trimmedPath(from: 0, to: min(max(progress, 0), 1)))
        result.addPath(second.trimmedPath(from: 0, to: min(max(progress - 1, 0), 1)))
        return result
    }
}

private struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let offset = 12 * sin(animatableData * .pi * 4)
        return ProjectionTransform(CGAffineTransform(translationX: offset, y: 0))
    }
}

