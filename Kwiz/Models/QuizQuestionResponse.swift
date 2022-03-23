//
//  QuizQuestionResponse.swift
//  Kwiz
//
//  Created by Megan Wynn on 17/11/2021.
//

import Foundation

enum Response: Codable {
    case correct
    case incorrect
}

struct QuizQuestionResponse: Codable {
    var quizQuestion: QuizQuestion
    var response: Response
    var dateCompleted: Date
}
