//
//  OddOneOutItem.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import Foundation

struct OddOneOutItem {
    let emoji: String
    let single: String
    let plural: String

    // For the members of a group ("flowers"): only the picture matters, they are never named.
    init(emoji: String, single: String = "", plural: String = "") {
        self.emoji = emoji
        self.single = single
        self.plural = plural
    }

    // "a tree", "an apple"
    var withArticle: String {
        let article = "aeiou".contains(single.lowercased().first ?? "x") ? "an" : "a"
        return "\(article) \(single)"
    }
}


