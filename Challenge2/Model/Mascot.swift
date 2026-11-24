//
//  Mascot.swift
//  Challenge2
//
//  Which mascot is shown and what it says when it is tapped.
//  To add a new mascot, add a static value below and pass it to the game.
//

import Foundation

struct Mascot {
    let imageName: String
    let encouragements: [String]

    /// The same mascot with different things to say, for screens that aren't a game.
    func saying(_ lines: [String]) -> Mascot {
        Mascot(imageName: imageName, encouragements: lines)
    }

    /// The mascot's reaction to a tap. Never the same line twice in a row.
    func encouragement(avoiding last: String?) -> String {
        let options = encouragements.filter { $0 != last }
        return options.randomElement() ?? encouragements.first ?? ""
    }
}

extension Mascot {
    private static let lines = [
        "You can do it!",
        "I believe in you!",
        "Take your time, you're doing great!",
        "Look at the picture closely!",
        "You're so smart!",
    ]

    static let neutral = Mascot(imageName: "mascot_genderless_neutral", encouragements: lines)
    static let happy = Mascot(imageName: "mascot_genderless_happy", encouragements: lines)
    static let celebrating = Mascot(imageName: "mascot_genderless_celebrating", encouragements: lines)
    static let sad = Mascot(imageName: "mascot_genderless_sad", encouragements: lines)
}
