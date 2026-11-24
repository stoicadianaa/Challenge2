//
//  PlantStage.swift
//  Challenge2
//
//  Created by Miriam Stellato on 19/11/2026.
//

import Foundation
                        // 0–2 drops: Seed.
let sproutFrom  = 3     //3–5 drops: Sprout
let growingFrom = 6    // 6–9 drops: Growing plant
let flowerFrom  = 10   //10 drops: Full flower

enum PlantStage: Int, CaseIterable {
    case seed, sprout, growing, flower

    static func from(drops: Int) -> PlantStage {
        if drops >= flowerFrom  { return .flower }
        if drops >= growingFrom { return .growing }
        if drops >= sproutFrom  { return .sprout }
        return .seed
    }

    var minDrops: Int {
        switch self {
        case .seed:    return 0
        case .sprout:  return sproutFrom
        case .growing: return growingFrom
        case .flower:  return flowerFrom
        }
    }

    var next: PlantStage? {
        PlantStage(rawValue: rawValue + 1)
    }

    var image: String {
        switch self {
        case .seed:    return "flower_step_1"
        case .sprout:  return "flower_step_2"
        case .growing: return "flower_step_3"
        case .flower:  return "flower_tulip" // fallback only: the garden shows the flower the child earned
        }
    }
}
