//
//  SettingsViewController.swift
//  Quiz
//
//  Created by Megan Wynn on 21/10/2021.
//

import UIKit

class SettingsViewController: UIViewController {

    private let difficultyControl = UISegmentedControl()
    private let numberOfQuestionControl = UISegmentedControl()
    private let numberOfQuestionsLabel = UILabel()
    private let difficultyLabel = UILabel()
    private let defaults: UserDefaults = .standard

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(updateButtonTapped(_:)))
        setupDifficultyLabel()
        setupDifficultyControl()
        setupNumberOfQuestionsLabel()
        setupQuestionNumberControl()
    }

    @objc func updateButtonTapped(_ sender: UIBarButtonItem) {
        defaults.set(difficultyControl.selectedSegmentIndex, forKey: "difficultyNumber")
        defaults.set(difficultyControl.titleForSegment(at: difficultyControl.selectedSegmentIndex)?.lowercased(), forKey: "difficultyTitle")
        defaults.set(numberOfQuestionControl.selectedSegmentIndex, forKey: "numberOfQuestionsIndex")
        defaults.set(numberOfQuestionControl.titleForSegment(at: numberOfQuestionControl.selectedSegmentIndex)?.lowercased(), forKey: "numberOfQuestions")
        dismiss(animated: true, completion: nil)
    }

    private func setupDifficultyLabel() {
        difficultyLabel.text = "Difficulty"
        setupGenericLabel(label: difficultyLabel)

        NSLayoutConstraint.activate([
            difficultyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            difficultyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (view.frame.width - 300) / 2),
            difficultyLabel.heightAnchor.constraint(equalToConstant: 40),
            difficultyLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setupDifficultyControl() {
        difficultyControl.insertSegment(withTitle: "Easy", at: 0, animated: false)
        difficultyControl.insertSegment(withTitle: "Medium", at: 1, animated: false)
        difficultyControl.insertSegment(withTitle: "Hard", at: 2, animated: false)
        difficultyControl.frame = CGRect(x: (view.frame.width - 300) / 2, y: 130, width: 300, height: 50)
        difficultyControl.selectedSegmentIndex = defaults.integer(forKey: "difficultyNumber")
        view.addSubview(difficultyControl)
    }

    private func setupNumberOfQuestionsLabel() {
        numberOfQuestionsLabel.text = "Number of questions"
        setupGenericLabel(label: numberOfQuestionsLabel)

        NSLayoutConstraint.activate([
            numberOfQuestionsLabel.topAnchor.constraint(equalTo: difficultyControl.bottomAnchor, constant: 20),
            numberOfQuestionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (view.frame.width - 300) / 2),
            numberOfQuestionsLabel.heightAnchor.constraint(equalToConstant: 40),
            numberOfQuestionsLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setupQuestionNumberControl() {
        numberOfQuestionControl.insertSegment(withTitle: "5", at: 0, animated: false)
        numberOfQuestionControl.insertSegment(withTitle: "10", at: 1, animated: false)
        numberOfQuestionControl.insertSegment(withTitle: "15", at: 2, animated: false)
        numberOfQuestionControl.frame = CGRect(x: (view.frame.width - 300) / 2, y: 250, width: 300, height: 50)
        numberOfQuestionControl.selectedSegmentIndex = defaults.integer(forKey: "numberOfQuestionsIndex")
        view.addSubview(numberOfQuestionControl)
    }

    private func setupGenericLabel(label: UILabel) {
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColour
        view.addSubview(label)
    }
}
