//
//  QuizQuestion.swift
//  Quiz
//
//  Created by Megan Wynn on 28/09/2021.
//

import Foundation

struct QuizQuestion: Codable, Equatable {
    var question: String
    var correctAnswer: String
    var incorrectAnswers: [String]

    func availableAnswers(numberOfResults num: Int) -> [String]? {
        guard num <= incorrectAnswers.count + 1 else { return nil }
        guard incorrectAnswers.count > 0 else { return nil }

        var answersArray: [String] = []
        answersArray.append(correctAnswer)

        while answersArray.count < num {
            let incorrectAnswer = incorrectAnswers.randomElement()!
            if answersArray.contains(incorrectAnswer) == false {
                answersArray.append(incorrectAnswer)
            }
        }
        return answersArray.shuffled()
    }
}
