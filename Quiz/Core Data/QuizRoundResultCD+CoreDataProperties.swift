//
//  QuizRoundResultCD+CoreDataProperties.swift
//  Quiz
//
//  Created by Megan Wynn on 09/02/2022.
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
    @NSManaged public var percentageCorrect: Int64
    @NSManaged public var resultString: String?
    @NSManaged public var startTime: Date?
    @NSManaged public var numberOfQuestions: Int64

}

extension QuizRoundResultCD : Identifiable {

}
