//
//  QuizRoundCoreDataPersistanceService.swift
//  Quiz
//
//  Created by Megan Wynn on 12/01/2022.
//

import Foundation
import CoreData

class QuizRoundCoreDataPersistanceService: QuizRoundPersistanceService {

    private var persistanceContainer: NSPersistentContainer
    private var allQuizRoundResults: [QuizRoundResult]?

    init() {
        persistanceContainer = NSPersistentContainer(name: "QuizCoreData")
        persistanceContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        fetchAllQuizRoundResults()
        print(QuizRoundJSONPersistanceService.getDocumentsDirectory().absoluteString)
    }

    func saveResult(_ result: QuizRoundResult) {
        let coreDataResult = QuizRoundResultCD(context: persistanceContainer.viewContext)
        coreDataResult.id = result.id
        coreDataResult.resultString = result.resultString
        coreDataResult.startTime = result.startTime
        coreDataResult.endTime = result.endTime
        coreDataResult.category = result.category
        saveIfNecessary()
        print("Save result called")
    }

    func getAllQuizRoundResults() -> [QuizRoundResult] {
        return self.allQuizRoundResults ?? []
    }

    private func saveIfNecessary() {
        if persistanceContainer.viewContext.hasChanges {
            do {
                try persistanceContainer.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }

    private func fetchAllQuizRoundResults() {
        DispatchQueue.global(qos: .userInitiated).async {

            let fetchRequest: NSFetchRequest<QuizRoundResultCD>
            fetchRequest = QuizRoundResultCD.fetchRequest()
            //fetchRequest.predicate = NSPredicate(format: "dateOfRide == %@", date as NSDate)

            var quizRoundResults: [QuizRoundResult]?
            do {
                let results = try self.persistanceContainer.viewContext.fetch(fetchRequest)
                quizRoundResults = results.compactMap( {QuizRoundResult(withQuizRoundResultCD: $0)} )
            } catch {
                print("Problem fetching QuizRoundResults")
            }

            DispatchQueue.main.async {
                self.allQuizRoundResults = quizRoundResults
            }
        }
    }
}
