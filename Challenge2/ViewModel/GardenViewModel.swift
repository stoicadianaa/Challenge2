//
//  GardenViewModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 19/11/2026.
//
import SwiftUI

@Observable
class GardenViewModel {

    var availableDrops: Int
    var plantDrops: Int
    // Reports the new (availableDrops, plantDrops) so the profile can be saved.
    @ObservationIgnored private let onChange: (Int, Int) -> Void

    init(availableDrops: Int, plantDrops: Int, onChange: @escaping (Int, Int) -> Void) {
        self.availableDrops = availableDrops
        self.plantDrops = plantDrops
        self.onChange = onChange
    }

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

        onChange(availableDrops, plantDrops)
    }

    func restart() {
        plantDrops = 0
        onChange(availableDrops, plantDrops)
    }
}
