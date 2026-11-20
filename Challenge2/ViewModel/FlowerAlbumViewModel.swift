//
//  FlowerAlbumViewModel.swift
//  Challenge2
//
//  Created by Diana Cristina Stoica on 19/11/2026.
//

import Foundation

@Observable
class FlowerAlbumViewModel {
    var flowers: [Flower] = [
        Flower(imageName: "flower_daisy", name: "Daisy", isUnlocked: true),
        Flower(imageName: "flower_tulip", name: "Tulip", isUnlocked: false),
        Flower(
            imageName: "flower_sunflower",
            name: "Sunflower",
            isUnlocked: true
        ),
        Flower(
            imageName: "flower_lilac_cosmos",
            name: "Lilac Cosmos",
            isUnlocked: true
        ),
        Flower(imageName: "flower_poppy", name: "Poppy", isUnlocked: true),
        Flower(
            imageName: "flower_bluebell",
            name: "Bluebell",
            isUnlocked: false
        ),
        Flower(
            imageName: "flower_buttercup",
            name: "Buttercup",
            isUnlocked: false
        ),
        Flower(imageName: "flower_sakura", name: "Sakura", isUnlocked: false),
        Flower(
            imageName: "flower_apricot_hibiscus",
            name: "Apricot Hibiscus",
            isUnlocked: false
        ),
        Flower(
            imageName: "flower_forgetmenot",
            name: "Forget-me-not",
            isUnlocked: false
        ),
        Flower(
            imageName: "flower_mint_lotus",
            name: "Mint Lotus",
            isUnlocked: false
        ),
        Flower(
            imageName: "flower_pink_blossom",
            name: "Pink Blossom",
            isUnlocked: false
        ),
        Flower(
            imageName: "flower_wildrose",
            name: "Wild Rose",
            isUnlocked: false
        ),
    ]
    
    var unlockedCount: Int {
        flowers.count(where: \.isUnlocked)
    }
}
