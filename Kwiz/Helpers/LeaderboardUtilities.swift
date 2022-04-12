//
//  LeaderboardUtilities.swift
//  Kwiz
//
//  Created by Megan Wynn on 24/03/2022.
//

import Foundation

enum LeaderboardStyle {
    case today0yesterday0earlier0
    case today1yesterday0earlier0
    case today0yesterday1earlier0
    case today0yesterday0earlier1
    case today1yesterday1earlier0
    case today1yesterday0earlier1
    case today0yesterday1earlier1
    case today1yesterday1earlier1
}

class LeaderboardUtilities {

    func leaderboardStyle(for todaysResults: [QuizRoundResult],
                          yesterdaysResults: [QuizRoundResult],
                          earlierResults: [QuizRoundResult]) -> LeaderboardStyle {
        if todaysResults.count == 0 {
            if yesterdaysResults.count == 0 {
                if earlierResults.count == 0 {
                    return .today0yesterday0earlier0
                } else {
                    return .today0yesterday0earlier1
                }
            } else {
                if earlierResults.count == 0 {
                    return .today0yesterday1earlier0
                } else {
                    return .today0yesterday1earlier1
                }
            }
        } else {
            if yesterdaysResults.count == 0 {
                if earlierResults.count == 0 {
                    return .today1yesterday0earlier0
                } else {
                    return .today1yesterday0earlier1
                }
            } else {
                if earlierResults.count == 0 {
                    return .today1yesterday1earlier0
                } else {
                    return .today1yesterday1earlier1
                }
            }
        }
    }
}
