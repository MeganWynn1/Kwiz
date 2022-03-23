//
//  QuizRoundPersistanceService.swift
//  Quiz
//
//  Created by Megan Wynn on 20/01/2022.
//

import Foundation

protocol QuizRoundPersistanceService {
    func saveResult(_ result: QuizRoundResult)
    func getAllQuizRoundResults() -> [QuizRoundResult]
    func clearAllData()
}
