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

    // Called once, when watering makes the plant a full flower. Returns the child's
    // unlocked flowers (imageNames) after the new one was added.
    @ObservationIgnored private let onFlowerCompleted: () -> [String]
    private var unlockedFlowers: [String]
    // The flower this plant turned into; nil while it hasn't flowered.
    private var earnedFlower: String?

    /// True once the child owns every flower of the catalog.
    var albumComplete: Bool { unlockedFlowers.count >= Flower.catalog.count }

    /// - Parameter unlockedFlowers: what the child owns; the last one is shown
    ///   if the plant is already fully grown when the garden opens.
    init(
        availableDrops: Int, plantDrops: Int, unlockedFlowers: [String],
        onChange: @escaping (Int, Int) -> Void,
        onFlowerCompleted: @escaping () -> [String]
    ) {
        self.availableDrops = availableDrops
        self.plantDrops = plantDrops
        self.onChange = onChange
        self.onFlowerCompleted = onFlowerCompleted
        self.unlockedFlowers = unlockedFlowers
        self.earnedFlower = plantDrops >= flowerFrom ? unlockedFlowers.last : nil
    }

    var stage: PlantStage {
        PlantStage.from(drops: plantDrops)
    }

    var plantImage: String {
        // The full flower is the one the child earned; the stage image is the fallback.
        if stage == .flower, let earnedFlower { return earnedFlower }
        return stage.image
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
        if stage == .flower {
            unlockedFlowers = onFlowerCompleted()
            earnedFlower = unlockedFlowers.last
        }
    }

    func restart() {
        plantDrops = 0
        earnedFlower = nil
        onChange(availableDrops, plantDrops)
    }
}
