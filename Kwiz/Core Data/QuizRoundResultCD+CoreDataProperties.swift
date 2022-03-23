//
//  QuizRoundResultCD+CoreDataProperties.swift
//  Kwiz
//
//  Created by Megan Wynn on 10/02/2022.
//
//

import Foundation
import CoreData


extension QuizRoundResultCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizRoundResultCD> {
        return NSFetchRequest<QuizRoundResultCD>(entityName: "QuizRoundResultCD")
    }

    @NSManaged public var category: String?
    @NSManaged public var endTime: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var difficulty: Int64
    @NSManaged public var percentageCorrect: Int64
    @NSManaged public var resultString: String?
    @NSManaged public var startTime: Date?

}

extension QuizRoundResultCD : Identifiable {

}

extension QuizRoundResult {
    init?(withQuizRoundResultCD coreDataObject: QuizRoundResultCD) {
        guard let id = coreDataObject.id else { return nil }
        self.id = id
        self.resultString = coreDataObject.resultString
        self.category = coreDataObject.category
        self.startTime = coreDataObject.startTime
        self.endTime = coreDataObject.endTime
        self.percentageCorrect = Int(coreDataObject.percentageCorrect)
        self.difficulty = Int(coreDataObject.difficulty)
    }
}
