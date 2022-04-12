//
//  LeaderboardUtilitiesTests.swift
//  KwizTests
//
//  Created by Megan Wynn on 24/03/2022.
//

import XCTest
@testable import Kwiz

class LeaderboardUtilitiesTests: XCTestCase {

    var sut: LeaderboardUtilities!

    func testReturnsCorrectLeaderboardStyle_forToday0yesterday0earlier0() {
        // Given
        sut = LeaderboardUtilities()

        // When
        let result = sut.leaderboardStyle(for: [], yesterdaysResults: [], earlierResults: [])

        // Then
        XCTAssertEqual(result, LeaderboardStyle.today0yesterday0earlier0)
    }

    func testReturnsCorrectLeaderboardStyle_forToday1yesterday0earlier0() {
        // Given
        sut = LeaderboardUtilities()
        let mockQuizRoundResult = QuizRoundResult(id: UUID())

        // When
        let result = sut.leaderboardStyle(for: [mockQuizRoundResult], yesterdaysResults: [], earlierResults: [])

        // Then
        XCTAssertEqual(result, LeaderboardStyle.today1yesterday0earlier0)
    }

    func testReturnsCorrectLeaderboardStyle_forToday1yesterday1earlier0() {
        // Given
        sut = LeaderboardUtilities()
        let mockQuizRoundResult = QuizRoundResult(id: UUID())

        // When
        let result = sut.leaderboardStyle(for: [mockQuizRoundResult], yesterdaysResults: [mockQuizRoundResult], earlierResults: [])

        // Then
        XCTAssertEqual(result, LeaderboardStyle.today1yesterday1earlier0)
    }

    func testReturnsCorrectLeaderboardStyle_forToday1yesterday1earlier1() {
        // Given
        sut = LeaderboardUtilities()
        let mockQuizRoundResult = QuizRoundResult(id: UUID())

        // When
        let result = sut.leaderboardStyle(for: [mockQuizRoundResult], yesterdaysResults: [mockQuizRoundResult], earlierResults: [mockQuizRoundResult])

        // Then
        XCTAssertEqual(result, LeaderboardStyle.today1yesterday1earlier1)
    }

    func testReturnsCorrectLeaderboardStyle_forToday0yesterday1earlier0() {
        // Given
        sut = LeaderboardUtilities()
        let mockQuizRoundResult = QuizRoundResult(id: UUID())

        // When
        let result = sut.leaderboardStyle(for: [], yesterdaysResults: [mockQuizRoundResult], earlierResults: [])

        // Then
        XCTAssertEqual(result, LeaderboardStyle.today0yesterday1earlier0)
    }

    func testReturnsCorrectLeaderboardStyle_forToday0yesterday1earlier1() {
        // Given
        sut = LeaderboardUtilities()
        let mockQuizRoundResult = QuizRoundResult(id: UUID())

        // When
        let result = sut.leaderboardStyle(for: [], yesterdaysResults: [mockQuizRoundResult], earlierResults: [mockQuizRoundResult])

        // Then
        XCTAssertEqual(result, LeaderboardStyle.today0yesterday1earlier1)
    }

    func testReturnsCorrectLeaderboardStyle_forToday0yesterday0earlier1() {
        // Given
        sut = LeaderboardUtilities()
        let mockQuizRoundResult = QuizRoundResult(id: UUID())

        // When
        let result = sut.leaderboardStyle(for: [], yesterdaysResults: [], earlierResults: [mockQuizRoundResult])

        // Then
        XCTAssertEqual(result, LeaderboardStyle.today0yesterday0earlier1)
    }

    func testReturnsCorrectLeaderboardStyle_forToday1yesterday0earlier1() {
        // Given
        sut = LeaderboardUtilities()
        let mockQuizRoundResult = QuizRoundResult(id: UUID())

        // When
        let result = sut.leaderboardStyle(for: [mockQuizRoundResult], yesterdaysResults: [], earlierResults: [mockQuizRoundResult])

        // Then
        XCTAssertEqual(result, LeaderboardStyle.today1yesterday0earlier1)
    }
}
