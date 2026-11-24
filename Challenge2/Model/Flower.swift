//
//  Flower.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 19/11/2026.
//

import Foundation

struct Flower: Identifiable {
    let id = UUID()
    let imageName: String // the name in the assets
    let name: String
    var isUnlocked: Bool

    /// Every flower in the game, in the order they get unlocked.
    /// Which ones a child owns is saved in ChildProfile.unlockedFlowers (by imageName).
    static let catalog: [(imageName: String, name: String)] = [
        ("flower_daisy", "Daisy"),
        ("flower_tulip", "Tulip"),
        ("flower_sunflower", "Sunflower"),
        ("flower_lilac_cosmos", "Lilac Cosmos"),
        ("flower_poppy", "Poppy"),
        ("flower_bluebell", "Bluebell"),
        ("flower_buttercup", "Buttercup"),
        ("flower_sakura", "Sakura"),
        ("flower_apricot_hibiscus", "Apricot Hibiscus"),
        ("flower_forgetmenot", "Forget-me-not"),
        ("flower_mint_lotus", "Mint Lotus"),
        ("flower_pink_blossom", "Pink Blossom"),
        ("flower_wildrose", "Wild Rose"),
    ]

    /// The whole album as one child sees it.
    static func album(unlocked: [String]) -> [Flower] {
        catalog.map {
            Flower(imageName: $0.imageName, name: $0.name, isUnlocked: unlocked.contains($0.imageName))
        }
    }
}
