//
//  WordMatchViewModel.swift
//  Challenge2
//
//  Created by Miriam Stellato on 22/11/2026.
//

import SwiftUI
import AVFoundation

@Observable
final class WordMatchViewModel {

    let questions = WordMatchQuestion.all

    var currentIndex = 0
    var score = 0                        // questions answered correctly at the first try
    var selectedAnswer: String?          // set when the child finds the right word
    var wrongAnswers: Set<String> = []   // wrong words already tried in this question
    var showReward = false

    private let onReward: (Int) -> Void
    private let synthesizer = AVSpeechSynthesizer()

    init(onReward: @escaping (Int) -> Void = { _ in }) {
        self.onReward = onReward
    }

    var question: WordMatchQuestion { questions[currentIndex] }
    var isAnswered: Bool { selectedAnswer != nil }
    var isLastQuestion: Bool { currentIndex == questions.count - 1 }

    var progress: Double {
        Double(currentIndex + (isAnswered ? 1 : 0)) / Double(questions.count)
    }

    var feedback: String {
        if isAnswered { return "Amazing! Well done!" }
        if !wrongAnswers.isEmpty { return "Try again! You can do it!" }
        return "Choose the matching word!"
    }

    func choose(_ choice: String) {
        guard !isAnswered else { return }

        if choice == question.word {
            selectedAnswer = choice
            if wrongAnswers.isEmpty { score += 1 }
            speak("Amazing! Well done!")
        } else {
            wrongAnswers.insert(choice)
            speak("Try again!")
        }
    }

    func next() {
        if isLastQuestion {
            onReward(1)
            showReward = true
            return
        }
        currentIndex += 1
        selectedAnswer = nil
        wrongAnswers = []
    }

    func restart() {
        currentIndex = 0
        score = 0
        selectedAnswer = nil
        wrongAnswers = []
    }

    func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.45
        synthesizer.speak(utterance)
    }
}
