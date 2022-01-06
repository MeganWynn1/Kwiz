//
//  Difficulty.swift
//  Quiz
//
//  Created by Megan Wynn on 26/10/2021.
//

import Foundation

enum Difficulty: String {
    case easy
    case medium
    case hard

    var numberOfAnswers: Int {
        switch self {
        case .easy:
            return 2
        case .medium:
            return 3
        case .hard:
            return 4
        }
    }
}
