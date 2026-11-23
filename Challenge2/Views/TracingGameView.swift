//
//  TracingGameView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//


import SwiftUI

struct TracingGameView: View {

    @State private var viewModel: TracingGameViewModel
    @Environment(\.dismiss) private var dismiss

    init(onReward: @escaping (Int) -> Void = { _ in }) {
        _viewModel = State(initialValue: TracingGameViewModel(onReward: onReward))
    }

    var body: some View {
        VStack(spacing: 16) {
            TraceReferenceCard(shape: viewModel.shape)
            TracePaletteBar(viewModel: viewModel)
            TraceDrawingArea(viewModel: viewModel)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .background {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .accessibilityHidden(true)
        }
        .overlay(alignment: .bottomTrailing) { mascot }
        .overlay {
            if viewModel.isCompleted {
                RewardScreen(onContinue: { dismiss() })
                    .transition(.opacity)
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.isCompleted)
        .navigationTitle("Trace & Draw")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(viewModel.isCompleted)
        .sensoryFeedback(.success, trigger: viewModel.isCompleted) { _, completed in completed }
    }

    private var mascot: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Text("Trace the dotted line!")
                .font(.system(.callout, design: .rounded, weight: .bold))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .glassEffect(.regular, in: .capsule)
                .padding(.bottom, 50)

            Image("mascot_genderless_happy")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
        }
        .padding(.trailing, 12)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

#Preview(traits: .landscapeLeft) {
    NavigationStack {
        TracingGameView()
    }
}
