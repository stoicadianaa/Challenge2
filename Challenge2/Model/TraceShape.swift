//
//  TraceShape.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import Foundation
import SwiftUI

/// How strict tracing is at one difficulty.
struct TraceRules {
    let lineWidth: CGFloat       // thicker pen = more forgiving
    let tolerance: CGFloat       // how far from the line still counts as "on" it
    let neededCoverage: Double   // share of the outline that must be covered
    let neededAccuracy: Double   // share of the pen's points that must be near the line
}

extension Difficulty {
    var traceRules: TraceRules {
        switch self {
        case .easy:   TraceRules(lineWidth: 24, tolerance: 44, neededCoverage: 0.70, neededAccuracy: 0.45)
        case .medium: TraceRules(lineWidth: 18, tolerance: 32, neededCoverage: 0.85, neededAccuracy: 0.55)
        case .hard:   TraceRules(lineWidth: 14, tolerance: 24, neededCoverage: 0.92, neededAccuracy: 0.70)
        }
    }
}

enum TraceShape: CaseIterable {
    case star, circle, triangle, square, heart

    var title: String {
        switch self {
        case .star:     "Star"
        case .circle:   "Circle"
        case .triangle: "Triangle"
        case .square:   "Square"
        case .heart:    "Heart"
        }
    }
    
    var color: Color {
        switch self {
        case .star:     .yellow
        case .circle:   .blue
        case .triangle: .green
        case .square:   .purple
        case .heart:    .red
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let pts = points(in: rect)
        guard let first = pts.first else { return path }
        path.move(to: first)
        pts.dropFirst().forEach { path.addLine(to: $0) }
        path.closeSubpath()
        return path
    }

    func points(in rect: CGRect) -> [CGPoint] {
        let side = min(rect.width, rect.height) * 0.8
        let box = CGRect(x: rect.midX - side / 2, y: rect.midY - side / 2, width: side, height: side)
        let c = CGPoint(x: box.midX, y: box.midY)
        let r = side / 2

        switch self {
        case .star:
            var v: [CGPoint] = []
            for i in 0..<10 {
                let angle = -Double.pi / 2 + Double(i) * Double.pi / 5
                let radius = i % 2 == 0 ? r : r * 0.40
                v.append(CGPoint(x: c.x + CGFloat(cos(angle)) * radius,
                                 y: c.y + CGFloat(sin(angle)) * radius))
            }
            return Self.densify(v)

        case .circle:
            return (0..<160).map { i in
                let a = Double(i) / 160 * 2 * Double.pi
                return CGPoint(x: c.x + CGFloat(cos(a)) * r, y: c.y + CGFloat(sin(a)) * r)
            }

        case .triangle:
            return Self.densify([
                CGPoint(x: c.x, y: box.minY),
                CGPoint(x: box.maxX, y: box.maxY),
                CGPoint(x: box.minX, y: box.maxY)
            ])

        case .square:
            let b = box.insetBy(dx: side * 0.08, dy: side * 0.08)
            return Self.densify([
                CGPoint(x: b.minX, y: b.minY), CGPoint(x: b.maxX, y: b.minY),
                CGPoint(x: b.maxX, y: b.maxY), CGPoint(x: b.minX, y: b.maxY)
            ])

        case .heart:
            return (0..<200).map { i in
                let t = Double(i) / 200 * 2 * Double.pi
                let x = 16 * pow(sin(t), 3)
                let y = 13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t)
                return CGPoint(x: c.x + CGFloat(x / 16) * r,
                               y: c.y - CGFloat((y + 2.5) / 14.5) * r)
            }
        }
    }

    private static func densify(_ v: [CGPoint], step: CGFloat = 6) -> [CGPoint] {
        var out: [CGPoint] = []
        for i in 0..<v.count {
            let a = v[i], b = v[(i + 1) % v.count]
            let n = max(1, Int(hypot(b.x - a.x, b.y - a.y) / step))
            for k in 0..<n {
                let t = CGFloat(k) / CGFloat(n)
                out.append(CGPoint(x: a.x + (b.x - a.x) * t, y: a.y + (b.y - a.y) * t))
            }
        }
        return out
    }
}

