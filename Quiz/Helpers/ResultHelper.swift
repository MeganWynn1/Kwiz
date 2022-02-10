//
//  ResultHelper.swift
//  Quiz
//
//  Created by Megan Wynn on 17/11/2021.
//

import Foundation

class ResultHelper {
    static func convertToPercentageString(score: Int, numberOfQuestions: Int) -> String {
        let score: Double = Double(score)
        let numberOfQuestions: Double = Double(numberOfQuestions)
        let percentage = round((score/numberOfQuestions) * 100)

        let percentageString = "\(Int(percentage))%"

        return percentageString
    }

    static func convertToPercentage(score: Int, numberOfQuestions: Int) -> Int {
        let score: Double = Double(score)
        let numberOfQuestions: Double = Double(numberOfQuestions)
        let percentage = round((score/numberOfQuestions) * 100)

        let percentageInt = Int(percentage)

        return percentageInt
    }

    static func convertToDecimal(score: Int, numberOfQuestions: Int) -> Float {
        let score: Double = Double(score)
        let numberOfQuestions: Double = Double(numberOfQuestions)

        let decimal = Float(score / numberOfQuestions)
        return decimal
    }

    static func createTimeInterval(score: Int, numberOfQuestions: Int) -> TimeInterval {
        let time = TimeInterval(Double(2) / ((Double(score) / Double(numberOfQuestions)) * 100))
        return time
    }
    
}
