//
//  TraceToolbars.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import SwiftUI

struct TraceReferenceCard: View {
    let shape: TraceShape

    var body: some View {
        VStack(spacing: 6) {
            GeometryReader { geo in
                shape.path(in: CGRect(origin: .zero, size: geo.size))
                    .fill(shape.color.gradient)
            }
            .frame(width: 90, height: 90)

            Text(shape.title)
                .font(.system(.headline, design: .rounded, weight: .bold))
        }
        .padding(14)
        .glassEffect(.regular, in: .rect(cornerRadius: 24))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Shape to trace: \(shape.title)")
    }
}

struct TracePaletteBar: View {
    let viewModel: TracingGameViewModel

    var body: some View {
        GlassEffectContainer(spacing: 16) {
            HStack(spacing: 16) {
                ForEach(Array(viewModel.palette.enumerated()), id: \.element.id) { index, item in
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
                    .scaleEffect(isSelected ? 1.15 : 1)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                    .accessibilityLabel(item.name)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }

                Button("Undo", systemImage: "arrow.uturn.backward", action: viewModel.undo)
                    .labelStyle(.iconOnly)
                    .buttonStyle(.glass)
                    .controlSize(.large)
                    .disabled(!viewModel.canUndo)

                Button("Clear", systemImage: "trash", role: .destructive, action: viewModel.clear)
                    .labelStyle(.iconOnly)
                    .buttonStyle(.glass)
                    .controlSize(.large)
                    .disabled(!viewModel.canUndo)
            }
        }
    }
}
