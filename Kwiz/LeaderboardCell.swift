//
//  LeaderboardCell.swift
//  Kwiz
//
//  Created by Megan Wynn on 27/10/2021.
//

import UIKit

class LeaderboardCell: BaseCell {

    // MARK: - UI Elements
    private var scoreLabel = UILabel()
    private var leaderboardNumber = UILabel()
    private var categoryLabel = UILabel()
    private var timeLabel = UILabel()
    private var stackView = UIStackView()

    // MARK: - Properties
    var cellNumber: Int? {
        didSet {
            leaderboardNumber.text = String(cellNumber!+1)
        }
    }
    var result: QuizRoundResult? {
        didSet {
            guard let result = result else { return }
            scoreLabel.text = String(result.resultString ?? "")
            categoryLabel.text = result.category
            timeLabel.text = "\(result.seconds)s"
        }
    }

    // MARK: - Initialise
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupLeaderboardLabel()
        setupCategoryLabel()
        setupTimeLabel()
        setupScoreLabel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.labelPadding),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.labelPadding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelPadding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.labelPadding)
        ])
    }

    private func setupGenericLabel(_ label: UILabel) {
        label.textColor = .textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(label)
    }

    private func setupLeaderboardLabel() {
        leaderboardNumber.font = Constants.boldFont
        setupGenericLabel(leaderboardNumber)
        NSLayoutConstraint.activate([
            leaderboardNumber.widthAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupScoreLabel() {
        scoreLabel.font = Constants.progressFont
        setupGenericLabel(scoreLabel)
    }

    private func setupCategoryLabel() {
        categoryLabel.textAlignment = .left
        categoryLabel.font = Constants.font
        setupGenericLabel(categoryLabel)
    }

    private func setupTimeLabel() {
        timeLabel.font = Constants.timeFont
        setupGenericLabel(timeLabel)
    }
}

// MARK: - Constants
extension LeaderboardCell {
    enum Constants {
        static let labelPadding: CGFloat = 5
        static let boldFont = UIFont.boldSystemFont(ofSize: 18)
        static let font = UIFont.systemFont(ofSize: 16)
        static let timeFont = UIFont.italicSystemFont(ofSize: 13)
        static let progressFont = UIFont.systemFont(ofSize: 18)
    }
}
