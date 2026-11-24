//
//  WordMatchViewModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import SwiftUI

// One Word Match game = one question. The session decides what comes next.
@MainActor
@Observable
final class WordMatchViewModel {

    let question: WordMatchQuestion
    let coach: MascotCoach

    var selectedAnswer: String?          // set when the child finds the right word
    var wrongAnswers: Set<String> = []   // wrong words already tried

    init(question: WordMatchQuestion, coach: MascotCoach? = nil) {
        self.question = question
        self.coach = coach ?? MascotCoach()
    }

    var isAnswered: Bool { selectedAnswer != nil }

    func choose(_ choice: String) {
        guard !isAnswered else { return }

        if choice == question.word {
            selectedAnswer = choice
            coach.say("Amazing! Well done!")
        } else {
            wrongAnswers.insert(choice)
            coach.say("Try again! You can do it!")
        }
    }
}
