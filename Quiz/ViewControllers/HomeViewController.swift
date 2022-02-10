//
//  HomeViewController.swift
//  Quiz
//
//  Created by Megan Wynn on 29/09/2021.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Private Properties
    private var startButton: QuizMenuButton!
    private var leaderboardButton: QuizMenuButton!
    private var logoImageView = UIImageView()

    // MARK: - Properties
    var quizRoundManager: QuizRoundResultsManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor

        let quizRoundPersistanceService = QuizRoundCoreDataPersistanceService()
        quizRoundManager = QuizRoundResultsManager(persistanceService: quizRoundPersistanceService)

        setUpNavigationView()
        setupStartButton()
        setupLeaderboardButton()
        addButtons()
        setupLogoImage()
    }

    // MARK: - Setup
    private func setUpNavigationView() {
        navigationController?.navigationBar.barTintColor = .backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationController?.navigationBar.tintColor = .titleColor

        let settingsButton = UIBarButtonItem(title: "Settings", style: .done, target: self, action: #selector(settingsButtonTapped(_:)))
        settingsButton.tintColor = .titleColor
        navigationItem.rightBarButtonItem = settingsButton
    }

    private func setupLogoImage() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = .appIcon
        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 250),
            logoImageView.widthAnchor.constraint(equalToConstant: 250)
        ])
    }

    private func setupStartButton() {
        startButton = QuizMenuButton(title: "START", backgroundColor: .mainColor)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
    }

    private func setupLeaderboardButton() {
        leaderboardButton = QuizMenuButton(title: "LEADERBOARD", backgroundColor: .mainColor2)
        leaderboardButton.translatesAutoresizingMaskIntoConstraints = false
        leaderboardButton.addTarget(self, action: #selector(leaderboardButtonTapped(_:)), for: .touchUpInside)
    }

    private func addButtons() {
        view.addSubview(startButton)
        view.addSubview(leaderboardButton)

        NSLayoutConstraint.activate([
            leaderboardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leaderboardButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.bottomPadding),
            leaderboardButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            leaderboardButton.widthAnchor.constraint(equalToConstant: view.frame.size.width/1.5),

            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: leaderboardButton.topAnchor, constant: -Constants.buttonSpacing),
            startButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            startButton.widthAnchor.constraint(equalToConstant: view.frame.size.width/1.5)
        ])
    }

    // MARK: Objective C Functions
    @objc func startButtonTapped(_ sender: QuizMenuButton) {
        let viewController = CategoryViewController()
        viewController.quizRoundManager = quizRoundManager
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func leaderboardButtonTapped(_ sender: QuizMenuButton) {
        let viewController = LeaderboardViewController()
        viewController.quizRoundManager = quizRoundManager
        let leaderboardNavigationController = UINavigationController(rootViewController: viewController)
        leaderboardNavigationController.isModalInPresentation = true
        present(leaderboardNavigationController, animated: true, completion: nil)
    }

    @objc func settingsButtonTapped(_ sender: UIBarButtonItem) {
        let viewController = SettingsViewController()
        let settingsNavigationController = UINavigationController(rootViewController: viewController)
        settingsNavigationController.isModalInPresentation = true
        present(settingsNavigationController, animated: true, completion: nil)
    }
}

// MARK: - Constants
extension HomeViewController {
    enum Constants {
        static let buttonHeight: CGFloat = 60
        static let bottomPadding: CGFloat = 100
        static let buttonSpacing: CGFloat = 20.0
    }
}
