//
//  QuizRoundCoreDataPersistanceService.swift
//  Kwiz
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
        coreDataResult.percentageCorrect = Int64(result.percentageCorrect ?? 0)
        coreDataResult.difficulty = Int64(result.difficulty ?? 0)
        saveIfNecessary()
    }

    func saveYesterdayMockData() {
        let coreDataResult = QuizRoundResultCD(context: persistanceContainer.viewContext)
        coreDataResult.id = UUID()
        coreDataResult.resultString = "30%"
        coreDataResult.startTime = Date(timeIntervalSinceReferenceDate: 669724498)
        coreDataResult.endTime = Date(timeIntervalSinceReferenceDate: 669724558)
        coreDataResult.category = "History"
        coreDataResult.percentageCorrect = 30
        coreDataResult.difficulty = 1
        saveIfNecessary()
    }

    func saveEarlierMockData() {
        let coreDataResult = QuizRoundResultCD(context: persistanceContainer.viewContext)
        coreDataResult.id = UUID()
        coreDataResult.resultString = "30%"
        coreDataResult.startTime = Date(timeIntervalSinceReferenceDate: 669381621)
        coreDataResult.endTime = Date(timeIntervalSinceReferenceDate: 669381681)
        coreDataResult.category = "History"
        coreDataResult.percentageCorrect = 30
        coreDataResult.difficulty = 2
        saveIfNecessary()
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

            self.fetchAllQuizRoundResults()
        }
    }

    public func fetchAllQuizRoundResults() {
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

    public func clearAllData() {
        let storeContainer = persistanceContainer.persistentStoreCoordinator

        do {
            // Delete each existing persistent store
            for store in storeContainer.persistentStores {
                try storeContainer.destroyPersistentStore( at: store.url!, ofType: store.type, options: nil)
            }
        } catch {
            print(error)
        }

        persistanceContainer = NSPersistentContainer(name: "QuizCoreData")
        persistanceContainer.loadPersistentStores { (store, error) in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }
//
//    public func presentEmailFeedback() {
//
//        let subject = "App Feedback - <App Name>"
//        let replyAddress = "blah@blah.com"
//
//        if MFMailComposeViewController.canSendMail() {
//            let mail = MFMailComposeViewController()
//            mail.mailComposeDelegate = self
//            mail.setToRecipients([replyAddress])
//            mail.setSubject(subject)
//            present(mail, animated: true)
//        } else {
//            let alertController = UIAlertController(title: "Email Error", message: "Email not configured for this device", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//            present(alertController, animated: true, completion: nil)
//        }
//    }
}

////MARK: - MFMailComposeViewControllerDelegate
//extension QuizRoundCoreDataPersistanceService: MFMailComposeViewControllerDelegate {
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true)
//    }
//}
