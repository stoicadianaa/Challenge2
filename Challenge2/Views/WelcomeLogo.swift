//
//  WelcomeLogo.swift
//  Challenge2
//
//  Created by Miriam Stellato on 21/11/2026.
//

import SwiftUI

struct WelcomeLogo: View {
    var title: String = "WonderBloom"
    var fontSize: CGFloat = 80

    private let darkWood = Color(red: 0.45, green: 0.24, blue: 0.09)
    private let lightWood = Color(red: 1.00, green: 0.86, blue: 0.57)
    private let warmWood = Color(red: 0.97, green: 0.72, blue: 0.36)
    private let textBrown = Color(red: 0.37, green: 0.18, blue: 0.05)

    var body: some View {
        Text(title)
            .font(.system(size: fontSize, weight: .heavy, design: .rounded))
            .foregroundStyle(textBrown)
            .shadow(color: .white.opacity(0.5), radius: 0, y: 2)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding(.horizontal, fontSize * 0.6)
            .padding(.vertical, fontSize * 0.28)
            .background { plank }
            .overlay(alignment: .topLeading) {
                leaves(flipped: false)
                    .offset(x: -fontSize * 0.2, y: -fontSize * 0.25)
            }
            .overlay(alignment: .topTrailing) {
                leaves(flipped: true)
                    .offset(x: fontSize * 0.2, y: -fontSize * 0.25)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(title)
            .accessibilityAddTraits(.isHeader)
    }

    private var plank: some View {
        let radius = fontSize * 0.3
        let border = fontSize * 0.09

        return ZStack {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(darkWood.gradient)

            RoundedRectangle(cornerRadius: radius * 0.75, style: .continuous)
                .fill(LinearGradient(colors: [lightWood, warmWood],
                                     startPoint: .top, endPoint: .bottom))
                .padding(border)

            RoundedRectangle(cornerRadius: radius * 0.75, style: .continuous)
                .strokeBorder(darkWood.opacity(0.35), lineWidth: fontSize * 0.015)
                .padding(border)

            HStack {
                nail
                Spacer()
                nail
            }
            .padding(.horizontal, border * 2)
        }
        .shadow(color: .black.opacity(0.25), radius: 8, y: 6)
    }

    private var nail: some View {
        Circle()
            .fill(darkWood.opacity(0.6))
            .frame(width: fontSize * 0.08, height: fontSize * 0.08)
    }

    private func leaves(flipped: Bool) -> some View {
        ZStack {
            Image(systemName: "leaf.fill")
                .rotationEffect(.degrees(-50))
                .offset(x: -fontSize * 0.08, y: fontSize * 0.04)

            Image(systemName: "leaf.fill")
                .rotationEffect(.degrees(10))
                .offset(x: fontSize * 0.1, y: -fontSize * 0.08)
        }
        .font(.system(size: fontSize * 0.42))
        .foregroundStyle(
            LinearGradient(colors: [Color(red: 0.62, green: 0.78, blue: 0.25),
                                    Color(red: 0.34, green: 0.58, blue: 0.20)],
                           startPoint: .top, endPoint: .bottom)
        )
        .shadow(color: .black.opacity(0.2), radius: 2, y: 2)
        .scaleEffect(x: flipped ? -1 : 1)
        .accessibilityHidden(true)
    }
}

#Preview {
        WelcomeLogo()
}
