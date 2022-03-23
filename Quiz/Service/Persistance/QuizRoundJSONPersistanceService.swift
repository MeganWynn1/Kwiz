//
//  QuizRoundJSONPersistanceService.swift
//  Quiz
//
//  Created by Megan Wynn on 03/11/2021.
//

import Foundation

class QuizRoundJSONPersistanceService: QuizRoundPersistanceService {

    private let filename = "results.json"
    private var allQuizRoundResults: [QuizRoundResult] = []

    init() {
        loadAllQuizRoundResults()
        print(QuizRoundJSONPersistanceService.getDocumentsDirectory().absoluteString)
    }

    private func loadAllQuizRoundResults() {

        let filename = QuizRoundJSONPersistanceService.getDocumentsDirectory().appendingPathComponent(filename)

        do {
            let savedData = try Data(contentsOf: filename)
            let jsonDecoder = JSONDecoder()
            let results = try jsonDecoder.decode([QuizRoundResult].self, from: savedData)

            allQuizRoundResults = results
        } catch {
            allQuizRoundResults = []
            print("Unable to read the file: \(error.localizedDescription)")
        }
    }

    public func saveResult(_ result: QuizRoundResult) {
        allQuizRoundResults.append(result)

        let filename = QuizRoundJSONPersistanceService.getDocumentsDirectory().appendingPathComponent(filename)

        do {
            let encoder = JSONEncoder()
            try encoder.encode(allQuizRoundResults).write(to: filename)
        } catch {
            print("FAILED")
        }
    }

    func clearAllData() { }


    public func getAllQuizRoundResults() -> [QuizRoundResult] {
        return allQuizRoundResults
    }

    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
