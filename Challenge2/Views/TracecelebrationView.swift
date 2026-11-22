//
//  TracecelebrationView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import SwiftUI

struct TraceCelebrationView: View {
    let onNext: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Amazing!")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))

                Label("+1", systemImage: "drop.fill")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(.blue)

                Button("Next shape", systemImage: "arrow.right", action: onNext)
                    .buttonStyle(.glassProminent)
                    .tint(.green)
                    .controlSize(.extraLarge)
            }
            .padding(36)
            .glassEffect(.regular, in: .rect(cornerRadius: 32))
        }
        .accessibilityAddTraits(.isModal)
    }
}

