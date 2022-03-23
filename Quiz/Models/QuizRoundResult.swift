//
//  QuizRoundResult.swift
//  Quiz
//
//  Created by Megan Wynn on 26/10/2021.
//

import Foundation

extension Date {

    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
}

enum SectionIdentifier: Int {
    case today
    case yesterday
    case earlier

    var headerTitle: String {
        switch self {
        case .today:
            return "Today"
        case .yesterday:
            return "Yesterday"
        case .earlier:
            return "Earlier"
        }
    }
}

struct QuizRoundResult: Codable {
    var id: UUID = UUID()
    var resultString: String?
    var category: String?
    var startTime: Date?
    var endTime: Date?
    var percentageCorrect: Int?
    var difficulty: Int?

    static func noResult() -> QuizRoundResult {
        return QuizRoundResult(id: UUID(), category: nil)
    }

    var isNoResult: Bool {
        return category == nil
    }

    var seconds: Int {
        return Int(endTime?.timeIntervalSinceReferenceDate ?? 0) - Int(startTime?.timeIntervalSinceReferenceDate ?? 0)
    }

    var date: Date {
        return startTime!.stripTime()
    }
}

extension QuizRoundResult: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension QuizRoundResult: Comparable {

    static func < (lhs: QuizRoundResult, rhs: QuizRoundResult) -> Bool {
        return lhs.percentageCorrect ?? 0 < rhs.percentageCorrect ?? 0
    }

    static func == (lhs: QuizRoundResult, rhs: QuizRoundResult) -> Bool {
        return lhs.id == rhs.id
    }
}
