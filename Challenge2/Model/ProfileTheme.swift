//
//  ProfileTheme.swift
//  Challenge2
//
//  Created by Gennara Vettoliere on 20/11/2026.
//

import Foundation
import SwiftUI

enum PF {
    static let blue   = Color(red: 0.36, green: 0.56, blue: 0.91)
    static let green  = Color(red: 0.51, green: 0.76, blue: 0.35)
    static let orange = Color(red: 0.96, green: 0.70, blue: 0.30)
    static let red    = Color(red: 0.90, green: 0.50, blue: 0.46)
    static let purple = Color(red: 0.62, green: 0.40, blue: 0.80)
    static let paper  = Color(red: 1.00, green: 0.99, blue: 0.96)
    static let brown  = Color(red: 0.36, green: 0.20, blue: 0.08)
    static let cream  = Color(red: 1.00, green: 0.93, blue: 0.75)

    static let ring: [Color] = [blue, green, orange, red, purple]
    static let avatars = ["🦊", "🐼", "🐯", "🐸", "🦄", "🐙", "🐰", "🐵"]
}

struct BouncyStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
