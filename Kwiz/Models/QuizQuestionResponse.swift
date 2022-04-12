//
//  QuizQuestionResponse.swift
//  Kwiz
//
//  Created by Megan Wynn on 17/11/2021.
//

import Foundation

enum Section {
    case main
}

enum Response: Codable {
    case correct
    case incorrect
}

struct QuizQuestionResponse: Codable {
    var id: UUID = UUID()
    var quizQuestion: QuizQuestion
    var response: Response
    var dateCompleted: Date

    static func fakeResponse() -> QuizQuestionResponse {
        return QuizQuestionResponse(quizQuestion: QuizQuestion(id: "", question: "", correctAnswer: "", incorrectAnswers: []), response: .correct, dateCompleted: Date.distantFuture)
    }
}

extension QuizQuestionResponse: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
