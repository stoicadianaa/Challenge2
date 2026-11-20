//
//  AvatarCicle.swift
//  Challenge2
//
//  Created by Gennara Vettoliere on 20/11/2026.
//

import SwiftUI

struct AvatarCircle: View {
    var emoji: String
    var size: CGFloat
    var ring: Color

    var body: some View {
        ZStack {
            Circle().fill(PF.paper)
            Text(emoji).font(.system(size: size * 0.55))
        }
        .frame(width: size, height: size)
        .overlay(Circle().stroke(ring, lineWidth: size * 0.01))
        .shadow(color: .black.opacity(0.2), radius: 6, y: 4)
    }
}

#Preview {
    AvatarCircle(
        emoji: PF.avatars.randomElement() ?? "🙂",
        size: 200,
        ring: PF.ring.randomElement() ?? .blue
    )
}
