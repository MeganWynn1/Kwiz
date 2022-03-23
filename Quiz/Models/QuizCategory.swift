//
//  QuizCategory.swift
//  Quiz
//
//  Created by Megan Wynn on 26/10/2021.
//

import Foundation

enum QuizCategory: Int, CaseIterable, Codable {
    case filmAndTv
    case music
    case foodAndDrink
    case generalKnowledge
    case geography
    case history
    case sportAndLeisure

    var urlString: String {
        switch self {
        case .filmAndTv:
            return "film%20&%20tv"
        case .music:
            return "music"
        case .foodAndDrink:
            return "food_and_drink"
        case .generalKnowledge:
            return "general_knowledge"
        case .geography:
            return "geography"
        case .history:
            return "history"
        case .sportAndLeisure:
            return "sport_and_leisure"
        }
    }

    var title: String {
        switch self {
        case .filmAndTv:
            return "Film and Tv"
        case .music:
            return "Music"
        case .foodAndDrink:
            return "Food and Drink"
        case .generalKnowledge:
            return "General Knowledge"
        case .geography:
            return "Geography"
        case .history:
            return "History"
        case .sportAndLeisure:
            return "Sport and Leisure"
        }
    }
}
