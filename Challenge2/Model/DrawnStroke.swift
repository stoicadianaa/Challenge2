//
//  DrawnStroke.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import Foundation
import SwiftUI

struct DrawnStroke: Identifiable {
    let id = UUID()
    var color: Color
    var points: [CGPoint] = []
    var covered: Set<Int> = []   // target points covered by this stroke
    var nearCount = 0            // how many stroke points are close to the outline
}

struct TraceColor: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

