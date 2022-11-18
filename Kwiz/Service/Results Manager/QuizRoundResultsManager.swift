//
//  QuizRoundResultsManager.swift
//  Kwiz
//
//  Created by Megan Wynn on 26/01/2022.
//

import Foundation

class QuizRoundResultsManager {

    var persistanceService: QuizRoundPersistanceService

    init(persistanceService: QuizRoundPersistanceService) {
        self.persistanceService = persistanceService
    }

    func saveResult(_ result: QuizRoundResult) {
        persistanceService.saveResult(result)
    }

    func getAllQuizRoundResults() -> [QuizRoundResult] {
        return persistanceService.getAllQuizRoundResults()
    }

    func clearAllData() {
        return persistanceService.clearAllData()
    }

    var todaysResults: [QuizRoundResult] = []
    var yesterdaysResults: [QuizRoundResult] = []
    var earlierResults: [QuizRoundResult] = []

    func getFilteredResults(difficulty: Int) {
        let filteredResults = getAllQuizRoundResults().filter({ $0.difficulty == difficulty })
        guard let yesterdaysDate = Calendar.current.date(byAdding: .day, value: -1, to: Date().stripTime()) else {
            print("Unable to calculate yesterday's date")
            return
        }

        todaysResults = filteredResults.filter({ $0.date == Date().stripTime() }).sorted { $0 == $1 ? $0.seconds < $1.seconds : $0 > $1 }
        yesterdaysResults = filteredResults.filter({ $0.date == yesterdaysDate }).sorted { $0 == $1 ? $0.seconds < $1.seconds : $0 > $1  }
        earlierResults = filteredResults.filter({ $0.date < yesterdaysDate }).sorted { $0 == $1 ? $0.seconds < $1.seconds : $0 > $1  }
    }
}
