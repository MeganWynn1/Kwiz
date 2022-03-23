//
//  ResultHelper.swift
//  Kwiz
//
//  Created by Megan Wynn on 17/11/2021.
//

import Foundation

class ResultHelper {
    static func convertToPercentageString(score: Int) -> String {
        let score: Double = Double(score)
        let percentage = round((score/10) * 100)

        let percentageString = "\(Int(percentage))%"

        return percentageString
    }

    static func convertToPercentage(score: Int) -> Int {
        let score: Double = Double(score)
        let percentage = round((score/10) * 100)

        let percentageInt = Int(percentage)

        return percentageInt
    }

    static func convertToDecimal(score: Int) -> Float {
        let score: Double = Double(score)

        let decimal = Float(score / 10)
        return decimal
    }

    static func createTimeInterval(score: Int) -> TimeInterval {
        let time = TimeInterval(Double(2) / ((Double(score) / Double(10)) * 100))
        return time
    }
    
}
