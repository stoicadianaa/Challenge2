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
}
