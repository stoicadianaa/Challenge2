//
//  TraceToolbars.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import SwiftUI

struct TraceReferenceCard: View {
    let shape: TraceShape
    @Environment(\.screenSize) private var screen

    var body: some View {
        VStack(spacing: screen.isCompact ? 2 : 6) {
            GeometryReader { geo in
                shape.path(in: CGRect(origin: .zero, size: geo.size))
                    .fill(shape.color.gradient)
            }
            // Smaller on a phone: in landscape a 90 pt card would cover the whole canvas.
            .frame(width: screen.value(regular: 90, portrait: 64, landscape: 44),
                   height: screen.value(regular: 90, portrait: 64, landscape: 44))

            Text(shape.title)
                .font(.system(screen.isCompact ? .caption : .headline, design: .rounded, weight: .bold))
        }
        .padding(screen.isCompact ? 8 : 14)
        .glassEffect(.regular, in: .rect(cornerRadius: 24))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Shape to trace: \(shape.title)")
    }
}

struct TracePaletteBar: View {
    let viewModel: TracingGameViewModel

    var body: some View {
        GlassEffectContainer(spacing: 16) {
            // One row when it fits; on a narrow phone the colours and the
            // undo/clear buttons sit on two rows. The buttons keep their size.
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 16) {
                    colors
                    actions
                }
                VStack(spacing: 12) {
                    HStack(spacing: 16) { colors }
                    HStack(spacing: 16) { actions }
                }
            }
        }
    }

    @ViewBuilder
    private var colors: some View {
        ForEach(Array(viewModel.palette.enumerated()), id: \.element.id)
        { index, item in
            let isSelected = index == viewModel.selectedColorIndex

            Button {
                viewModel.selectedColorIndex = index
            } label: {
                Circle()
                    .fill(item.color)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle().strokeBorder(.white, lineWidth: isSelected ? 4 : 0)
                    )
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .controlSize(.large)
            .accessibilityLabel(item.name)
            .accessibilityAddTraits(isSelected ? .isSelected : [])
        }
    }

    @ViewBuilder
    private var actions: some View {
                Button(
                    "Undo",
                    systemImage: "arrow.uturn.backward",
                    action: viewModel.undo
                )
                .labelStyle(.iconOnly)
                .buttonStyle(.glass)
                .controlSize(.large)
                .disabled(!viewModel.canUndo)

                Button(
                    "Clear",
                    systemImage: "trash",
                    role: .destructive,
                    action: viewModel.clear
                )
                .labelStyle(.iconOnly)
                .buttonStyle(.glass)
                .controlSize(.large)
                .disabled(!viewModel.canUndo)
    }
}
