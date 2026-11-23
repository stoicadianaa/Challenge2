//
//  TracingGameViewModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import Foundation
import SwiftUI

@Observable
final class TracingGameViewModel {

    let shapes = TraceShape.allCases
    let palette: [TraceColor] = [
        TraceColor(name: "Red",    color: .red),
        TraceColor(name: "Blue",   color: .blue),
        TraceColor(name: "Green",  color: .green),
        TraceColor(name: "Orange", color: .orange),
        TraceColor(name: "Purple", color: .purple)
    ]

    // A round is one shape; pick a different one each time.
    var shapeIndex = Int.random(in: 0..<TraceShape.allCases.count)
    var selectedColorIndex = 3
    var strokes: [DrawnStroke] = []
    var current: DrawnStroke?
    var isCompleted = false

    // Rules (change these numbers to make it easier or harder)
    let lineWidth: CGFloat = 18
    private let tolerance: CGFloat = 32
    private let neededCoverage = 0.85
    private let neededAccuracy = 0.55

    private let onReward: (Int) -> Void

    init(onReward: @escaping (Int) -> Void = { _ in }) {
        self.onReward = onReward
    }

    var shape: TraceShape { shapes[shapeIndex] }
    var selectedColor: Color { palette[selectedColorIndex].color }
    var allStrokes: [DrawnStroke] { strokes + (current.map { [$0] } ?? []) }
    var canUndo: Bool { !strokes.isEmpty }

    func drag(to point: CGPoint, target: [CGPoint]) {
        guard !isCompleted else { return }

        if current == nil {
            current = DrawnStroke(color: selectedColor)
        }
        current?.points.append(point)

        var isNear = false
        for (i, t) in target.enumerated() where hypot(t.x - point.x, t.y - point.y) < tolerance {
            current?.covered.insert(i)
            isNear = true
        }
        if isNear { current?.nearCount += 1 }
    }

    func endStroke(targetCount: Int) {
        guard !isCompleted else { return }
        if let stroke = current { strokes.append(stroke) }
        current = nil
        checkCompletion(targetCount: targetCount)
    }

    func undo() {
        if !strokes.isEmpty { strokes.removeLast() }
    }

    func clear() {
        strokes.removeAll()
        current = nil
    }

    private func checkCompletion(targetCount: Int) {
        guard targetCount > 0 else { return }

        var covered = Set<Int>()
        var near = 0, total = 0
        for s in strokes {
            covered.formUnion(s.covered)
            near += s.nearCount
            total += s.points.count
        }

        let coverage = Double(covered.count) / Double(targetCount)
        let accuracy = total > 0 ? Double(near) / Double(total) : 0

        if coverage >= neededCoverage && accuracy >= neededAccuracy {
            isCompleted = true
            onReward(1)   // credit the drop now, so leaving the reward screen can't lose it
        }
    }
}
