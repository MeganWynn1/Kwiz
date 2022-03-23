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

    func getUsersPopularCategories() -> [PopularCategory] {
        let allQuizRoundResults = getAllQuizRoundResults()
        var userPopularCategoriesArray: [PopularCategory] = []

        for result in allQuizRoundResults {
            guard let resultCategoryName = result.category else { continue }
            if var popularCategory = userPopularCategoriesArray.filter({ $0.category == resultCategoryName }).first {
                let index = userPopularCategoriesArray.firstIndex { $0.category == resultCategoryName }!
                var popularCategoryCount = popularCategory.count
                popularCategoryCount += 1
                popularCategory.count = popularCategoryCount
                userPopularCategoriesArray[index] = popularCategory
            } else {
                let newPopularCategory = PopularCategory(category: resultCategoryName, count: 1)
                userPopularCategoriesArray.append(newPopularCategory)
            }
        }

        print("Users popular categories:", userPopularCategoriesArray)
        return userPopularCategoriesArray
    }

    func getCategoriesWithTopScores() -> [CategoryTopScore] {
        let allQuizRoundResults = getAllQuizRoundResults()
        var categoryTopScores: [CategoryTopScore] = []

        for result in allQuizRoundResults {
            guard let resultCategoryName = result.category else { continue }
            guard let finalResult =  result.percentageCorrect else { continue }
            if var topScore = categoryTopScores.filter({ $0.category == resultCategoryName }).first {
                let index = categoryTopScores.firstIndex { $0.category == resultCategoryName }!
                if finalResult > topScore.result {
                    topScore.result = finalResult
                    categoryTopScores[index] = topScore
                }
            } else {
                let newTopScore = CategoryTopScore(category: resultCategoryName, result: finalResult)
                categoryTopScores.append(newTopScore)
            }
        }
        print("Top scores of played categories:", categoryTopScores)
        return categoryTopScores
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

    func getPerfectScoreSplit() -> PerfectScoreSplit? {
        return nil
    }

    func getPerfectScoreSplitForCategory() -> [PerfectScoreSplit] {
        return []
    }
}
