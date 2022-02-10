//
//  QuizQuestionService.swift
//  Quiz
//
//  Created by Megan Wynn on 28/09/2021.
//

import Foundation
import Combine

public enum QuizQuestionServiceError: Error, Equatable {
    case missingData
    case noInternetConnection
    case invalidResponseError
}

class QuizQuestionService {

    public func getQuestions(category: String, number: Int, with completion: @escaping (Result<[QuizQuestion], QuizQuestionServiceError>) -> Void) {
        let url = URL(string: "https://api.trivia.willfry.co.uk/questions?categories=\(category)&limit=\(number)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.noInternetConnection))
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    return completion(.failure(.invalidResponseError))
                }
                guard let data = data else {
                    return completion(.failure(.missingData))
                }

                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode([QuizQuestion].self, from: data)
                    return completion(.success(data))
                }
                catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}


