//
//  TracingGameViewModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class TracingGameViewModel {

    let shape: TraceShape
    let palette: [TraceColor] = [
        TraceColor(name: "Red",    color: .red),
        TraceColor(name: "Blue",   color: .blue),
        TraceColor(name: "Green",  color: .green),
        TraceColor(name: "Orange", color: .orange),
        TraceColor(name: "Purple", color: .purple)
    ]

    var selectedColorIndex = 3
    var strokes: [DrawnStroke] = []
    var current: DrawnStroke?
    var isCompleted = false

    // Set by the difficulty (see Difficulty.traceRules)
    private let rules: TraceRules
    var lineWidth: CGFloat { rules.lineWidth }
    private var tolerance: CGFloat { rules.tolerance }

    let coach: MascotCoach
    // Undo / Clear / a "not quite" stroke mean the child had to redo something.
    private var redoCount = 0
    // How far below the needed coverage still counts as "close" (0.25 = within 25 points).
    private let closeMargin = 0.25

    var solvedFirstTry: Bool { redoCount == 0 }

    init(shape: TraceShape, difficulty: Difficulty, coach: MascotCoach? = nil) {
        self.shape = shape
        self.rules = difficulty.traceRules
        self.coach = coach ?? MascotCoach()
    }

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
        if !strokes.isEmpty { strokes.removeLast(); redoCount += 1 }
    }

    func clear() {
        if !strokes.isEmpty { redoCount += 1 }
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

        if coverage >= rules.neededCoverage && accuracy >= rules.neededAccuracy {
            isCompleted = true
            coach.say("Amazing! Well done!")
        } else if coverage >= rules.neededCoverage - closeMargin {
            // Close, but not there yet: tell the child instead of leaving them guessing.
            redoCount += 1
            coach.sayIfQuiet(accuracy < rules.neededAccuracy
                ? "So close! Try to stay on the dotted line."
                : "Almost there! Trace the rest of the line.")
        }
    }
}
