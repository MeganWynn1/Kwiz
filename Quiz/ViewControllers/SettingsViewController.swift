//
//  SettingsViewController.swift
//  Quiz
//
//  Created by Megan Wynn on 21/10/2021.
//

import UIKit

class SettingsViewController: UIViewController {

    private let difficultyControl = UISegmentedControl()
    private let difficultyLabel = UILabel()
    private let defaults: UserDefaults = .standard

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.titleColor]
        let updateButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped(_:)))
        updateButton.tintColor = .titleColor
        navigationItem.rightBarButtonItem = updateButton
        setupDifficultyLabel()
        setupDifficultyControl()
    }

    @objc func saveButtonTapped(_ sender: UIBarButtonItem) {
        defaults.set(difficultyControl.selectedSegmentIndex, forKey: "difficulty")
        defaults.set(difficultyControl.titleForSegment(at: difficultyControl.selectedSegmentIndex)?.lowercased(), forKey: "difficultyTitle")
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
        difficultyControl.selectedSegmentIndex = defaults.integer(forKey: "difficulty")
        difficultyControl.selectedSegmentTintColor = .mainColor
        difficultyControl.backgroundColor = .mainColor2
        difficultyControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        view.addSubview(difficultyControl)
    }

    private func setupGenericLabel(label: UILabel) {
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .titleColor
        view.addSubview(label)
    }
}
