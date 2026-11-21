//
//  SpeechBubbleView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 21/11/2026.
//

import SwiftUI

struct BubbleShape: Shape {
    var cornerRadius: CGFloat = 28
    var tailSize: CGFloat = 22

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let body = CGRect(x: rect.minX, y: rect.minY,
                          width: rect.width, height: rect.height - tailSize)
        path.addRoundedRect(in: body,
                            cornerSize: CGSize(width: cornerRadius, height: cornerRadius),
                            style: .continuous)

        let startX = rect.minX + cornerRadius
        var tail = Path()
        tail.move(to: CGPoint(x: startX, y: body.maxY - 1))
        tail.addLine(to: CGPoint(x: startX - tailSize * 0.6, y: rect.maxY))
        tail.addLine(to: CGPoint(x: startX + tailSize * 1.2, y: body.maxY - 1))
        tail.closeSubpath()

        path.addPath(tail)
        return path
    }
}

struct SpeechBubble: View {
    let text: String
    private let tailSize: CGFloat = 22

    var body: some View {
        Text(text)
            .font(.system(.title, design: .rounded, weight: .heavy))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 28)
            .padding(.top, 16)
            .padding(.bottom, 16 + tailSize)
            .glassEffect(.regular, in: BubbleShape(tailSize: tailSize))
    }
}

#Preview {
        SpeechBubble(text: "I’m Bloomy!")
}
