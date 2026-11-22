//
//  TraceDrawingArea.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import SwiftUI

struct TraceDrawingArea: View {
    
    let viewModel: TracingGameViewModel

    var body: some View {
        GeometryReader { geo in
            let rect = CGRect(origin: .zero, size: geo.size)
            let target = viewModel.shape.points(in: rect)
            let strokes = viewModel.allStrokes
            let lineWidth = viewModel.lineWidth

            ZStack {
                viewModel.shape.path(in: rect)
                    .stroke(.secondary,
                            style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [10, 9]))

                Canvas { context, _ in
                    for stroke in strokes {
                        guard let first = stroke.points.first else { continue }
                        var path = Path()
                        path.move(to: first)
                        if stroke.points.count == 1 {
                            path.addLine(to: CGPoint(x: first.x + 0.1, y: first.y))   // a single tap draws a dot
                        }
                        stroke.points.dropFirst().forEach { path.addLine(to: $0) }
                        context.stroke(path, with: .color(stroke.color),
                                       style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                    }
                }
                .allowsHitTesting(false)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { viewModel.drag(to: $0.location, target: target) }
                    .onEnded { _ in viewModel.endStroke(targetCount: target.count) }
            )
            .accessibilityElement()
            .accessibilityLabel("Drawing area")
            .accessibilityHint("Trace the \(viewModel.shape.title) with your finger or Apple Pencil")
            .accessibilityAddTraits(.allowsDirectInteraction)
        }
    }
}
