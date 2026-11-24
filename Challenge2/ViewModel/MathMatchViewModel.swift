//
//  MathMatchViewModel.swift
//  Challenge2
//
//  One Math Match game = one question. The session decides what comes next.
//

import SwiftUI

@MainActor
@Observable
final class MathMatchViewModel {

    let question: MathQuestion
    let coach: MascotCoach
    let choices: [Int]                   // shuffled, so the answer isn't always in the same place

    var selectedAnswer: Int?             // set when the child finds the right number
    var wrongAnswers: Set<Int> = []      // wrong numbers already tried

    init(question: MathQuestion, coach: MascotCoach? = nil) {
        self.question = question
        self.coach = coach ?? MascotCoach()
        choices = question.choices.shuffled()
    }

    var isAnswered: Bool { selectedAnswer != nil }

    func choose(_ choice: Int) {
        guard !isAnswered else { return }

        if choice == question.answer {
            selectedAnswer = choice
            coach.say("Amazing! Well done!")
        } else {
            wrongAnswers.insert(choice)
            coach.say("Try again! You can do it!")
        }
    }
}
