//
//  ProfileStore.swift
//  Challenge2
//
//  Created by Gennara Vettoliere on 20/11/2026.
//

import Foundation
import Combine

final class ProfileStore: ObservableObject {
    @Published var profiles: [ChildProfile] = [] {
        didSet { save() }
    }

    private let key = "wonderwood.childProfiles"
    static let maxProfiles = 6

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([ChildProfile].self, from: data) {
            profiles = decoded
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func add(_ profile: ChildProfile) {
        profiles.append(profile)
    }

    /// Replaces the stored copy of a profile (the `profiles` observer persists it).
    func update(_ profile: ChildProfile) {
        guard let index = profiles.firstIndex(where: { $0.id == profile.id }) else { return }
        profiles[index] = profile
    }

    func delete(_ profile: ChildProfile) {
        profiles.removeAll { $0.id == profile.id }
    }
}
