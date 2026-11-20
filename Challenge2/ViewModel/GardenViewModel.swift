//
//  GardenViewModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 19/11/2026.
//
import SwiftUI

@Observable
class GardenViewModel {

    var availableDrops = UserDefaults.standard.integer(forKey: "waterDrops")

    var plantDrops = UserDefaults.standard.integer(forKey: "plantDrops")

    var stage: PlantStage {
        PlantStage.from(drops: plantDrops)
    }

    var plantImage: String {
        stage.image
    }
    
    var dropsToNextStage: Int {
        guard let next = stage.next else { return 0 }
        return next.minDrops - plantDrops
    }

    var mascotImage: String {
        if stage == .flower { return "mascot_genderless_celebrating" }
        if availableDrops == 0 { return "mascot_genderless_sad" }
        return "mascot_genderless_happy"
    }

    func water() {
        if availableDrops == 0 || stage == .flower { return }

        availableDrops -= 1
        plantDrops += 1

        UserDefaults.standard.set(availableDrops, forKey: "waterDrops")
        UserDefaults.standard.set(plantDrops, forKey: "plantDrops")
    }

    func restart() {
        plantDrops = 0
        UserDefaults.standard.set(0, forKey: "plantDrops")
    }
}
