//
//  ChildProfile.swift
//  Challenge2
//
//  Created by Gennara Vettoliere on 20/11/2026.
//

import Foundation

struct ChildProfile: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var avatar: String
    /// Level and streaks per category. Missing category = never played = starts at Easy.
    var progress: [GameType: SkillProgress] = [:]
    /// Drops earned and not yet used on the plant.
    var waterDrops = 0
    /// Drops already poured on the current plant.
    var plantDrops = 0

    init(id: UUID = UUID(), name: String, avatar: String) {
        self.id = id
        self.name = name
        self.avatar = avatar
    }

    // Custom decoding so profiles saved before `progress` existed still load.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        avatar = try c.decode(String.self, forKey: .avatar)
        progress = try c.decodeIfPresent([GameType: SkillProgress].self, forKey: .progress) ?? [:]
        waterDrops = try c.decodeIfPresent(Int.self, forKey: .waterDrops) ?? 0
        plantDrops = try c.decodeIfPresent(Int.self, forKey: .plantDrops) ?? 0
    }
}
