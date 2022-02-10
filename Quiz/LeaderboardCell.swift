//
//  LeaderboardCell.swift
//  Quiz
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

    // MARK: - Private Properties
    private var circularProgressView: CircularProgressView?
    private var decimalProgress: Float?

    // MARK: - Properties
    var cellNumber: Int? {
        didSet {
            leaderboardNumber.text = String(cellNumber!+1)
        }
    }
    var result: QuizRoundResult? {
        didSet {
            guard let result = result else { return }
            scoreLabel.text = String(result.resultString!)
            categoryLabel.text = result.category
            timeLabel.text = "\(result.seconds)s"
            decimalProgress = ResultHelper.convertToDecimal(score: result.numberOfCorrectAnswers)
        }
    }

    // MARK: - Initialise
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLeaderboardLabel()
        setupScoreLabel()
        setupCategoryLabel()
        setupTimeLabel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setUpCircularProgressBarView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setUpCircularProgressBarView() {
        circularProgressView = CircularProgressView()
        circularProgressView?.alpha = 1.0
        circularProgressView?.createStaticView(x: contentView.frame.size.width - 40, y: contentView.frame.size.height / 2.0, strokeEnd: CGFloat(decimalProgress ?? 0))
        contentView.addSubview(circularProgressView!)
    }

    private func setupGenericLabel(_ label: UILabel) {
        label.textColor = .textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
    }

    private func setupLeaderboardLabel() {
        leaderboardNumber.textAlignment = .center
        leaderboardNumber.font = Constants.boldFont
        setupGenericLabel(leaderboardNumber)
        NSLayoutConstraint.activate([
            leaderboardNumber.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.labelPadding),
            leaderboardNumber.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.labelPadding),
            leaderboardNumber.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelPadding),
            leaderboardNumber.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupScoreLabel() {
        scoreLabel.textAlignment = .center
        scoreLabel.font = Constants.progressFont
        setupGenericLabel(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.labelPadding),
            scoreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.labelPadding),
            scoreLabel.widthAnchor.constraint(equalToConstant: 40),
            scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    private func setupCategoryLabel() {
        categoryLabel.font = Constants.font
        setupGenericLabel(categoryLabel)
        NSLayoutConstraint.activate([
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.labelPadding),
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.labelPadding),
            categoryLabel.leadingAnchor.constraint(equalTo: leaderboardNumber.trailingAnchor, constant: Constants.labelPadding),
            categoryLabel.widthAnchor.constraint(equalToConstant: 160)
        ])
    }

    private func setupTimeLabel() {
        timeLabel.font = Constants.timeFont
        setupGenericLabel(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.labelPadding),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.labelPadding),
            timeLabel.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor, constant: -20)
        ])
    }
}

// MARK: - Constants
extension LeaderboardCell {
    enum Constants {
        static let labelPadding: CGFloat = 10
        static let boldFont = UIFont.boldSystemFont(ofSize: 18)
        static let font = UIFont.systemFont(ofSize: 18)
        static let timeFont = UIFont.italicSystemFont(ofSize: 15)
        static let progressFont = UIFont.systemFont(ofSize: 12)
    }
}
