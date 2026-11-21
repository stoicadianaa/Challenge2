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
}
