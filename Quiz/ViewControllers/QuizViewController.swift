//
//  QuizViewController.swift
//  Quiz
//
//  Created by Megan Wynn on 28/09/2021.
//

import UIKit
import Combine

class QuizViewController: UIViewController {

    // MARK: - Properties
    var category: QuizCategory!
    var quizRoundManager: QuizRoundResultsManager!

    // MARK: - Private Properties
    private let quizQuestionService = QuizQuestionService()
    private let defaults: UserDefaults = .standard
    private var currentQuestion: QuizQuestion?
    private var questions: [QuizQuestion] = []
    private var score: Int = 0
    private var percentage: Int?
    private var currentCount: Int?
    private var updateTimer: Timer?
    private var identifier = "QuestionsCell"
    private var quizQuestionResponses: [QuizQuestionResponse] = []
    private var quizRoundStartDate: Date!

    // MARK: - UI Elements
    private var questionLabel = UILabel()
    private var percentageLabel = UILabel()
    private var answerStack = UIStackView()
    private var answerButtonCollection = [AnswerButton]()
    private var completedLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var circularProgressView: CircularProgressView?
    private var spinner: UIActivityIndicatorView!
    private var completedCollectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(quizRoundManager != nil)
        configure()
        completedLabel.alpha = 0.0
        circularProgressView?.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getQuestions()
        addViews()
    }

    private func configure() {
        guard category != nil else { fatalError("Category must be set") }
        view.backgroundColor = .backgroundColor
        title = category.title
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.titleColor]

        let quitButton = UIBarButtonItem(title: "Quit", style: .done, target: self, action: #selector(quitButtonTapped(_:)))
        quitButton.tintColor = .titleColor
        navigationItem.rightBarButtonItem = quitButton
    }

    private func setUpCircularProgressBarView(toValue: Float) {
        circularProgressView = CircularProgressView()
        circularProgressView?.center = CGPoint(x: view.center.x, y: view.frame.size.height / 4.0)
        circularProgressView?.progressAnimation(toValue: toValue)
        circularProgressView?.createCircularPath()
        view.addSubview(circularProgressView!)

        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.textAlignment = .center
        percentageLabel.textColor = .titleColor
        percentageLabel.font = UIFont.preferredFont(forTextStyle: .headline).withSize(26)
        view.addSubview(percentageLabel)

        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            percentageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: (view.frame.size.height / 4.0) - 30),
            percentageLabel.heightAnchor.constraint(equalToConstant: 60),
            percentageLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.size.width-60, height: 70)
        completedCollectionView = UICollectionView(frame: CGRect(x: 0, y: self.view.frame.height / 2.0, width: self.view.frame.width, height: self.view.frame.height / 2.0), collectionViewLayout: layout)

        guard let collectionView = completedCollectionView else { return }
        collectionView.register(CompletedQuestionsCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = .backgroundColor

        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)
    }

    private func showSpinner() {
        spinner = UIActivityIndicatorView(style: .large)
        spinner.center = view.center
        spinner.startAnimating()
        self.view.addSubview(spinner)

        questionLabel.alpha = 0.0
        for button in answerButtonCollection {
            button.alpha = 0.0
        }
    }

    private func removeSpinner() {
        spinner.stopAnimating()

        UIView.animate(withDuration: 0.4) {
            self.questionLabel.alpha = 1.0
            for button in self.answerButtonCollection {
                button.alpha = 1.0
            }
        }
    }

    private func getQuestions() {
        showSpinner()
        quizQuestionService.getQuestions(category: category.urlString) { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.removeSpinner()
                self.quizRoundStartDate = Date()
                switch result {
                case .success(let questions):
                    self.questions = questions.shuffled()
                    self.presentNextQuestion(animated: false)
                case .failure(_):
                    print("error")
                }
            }
        }
    }

    private func presentNextQuestion(animated: Bool) {
        if let currentQuestion = currentQuestion, let currentQuestionIndex = questions.firstIndex(where: {$0 == currentQuestion}) {
            let nextQuestionIndex = questions.index(after: currentQuestionIndex)
            if nextQuestionIndex < questions.count {
                self.currentQuestion = questions[nextQuestionIndex]
            } else {
                quizRoundEnded()
                return
            }
        } else {
            guard let question = questions.first else { return }
            self.currentQuestion = question
        }

        for button in answerButtonCollection {
            button.removeFromSuperview()
        }
        answerButtonCollection.removeAll()
        addQuestion(question: currentQuestion!)
    }

    private func addQuestion(question: QuizQuestion) {
        let difficultyTitle = defaults.string(forKey: "difficultyTitle") ?? "easy"
        let number = Difficulty(rawValue: difficultyTitle)?.numberOfAnswers ?? 2
        guard let answersArray = question.availableAnswers(numberOfResults: number) else {
            print("Invalid number of available answers")
            return
        }
        questionLabel.text = question.question
        for num in 0..<number {
            let button = AnswerButton()
            answerButtonCollection.append(button)
            answerStack.addArrangedSubview(button)
            button.setTitle(answersArray[num], for: .normal)
            button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
            button.isEnabled = true

            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: Constants.answerButtonHeight)
            ])
        }
        print(currentQuestion!.correctAnswer)
    }

    // MARK: Add views
    private func addViews() {
        setupQuestionLabel()
        setupStackView()
        view.addSubview(questionLabel)
        view.addSubview(answerStack)

        NSLayoutConstraint.activate([
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topPadding),
            questionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: Constants.sidePadding),
            questionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -Constants.sidePadding),

            answerStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.topPadding),
            answerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sidePadding),
            answerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sidePadding)
        ])
    }

    // MARK: Setup
    private func setupQuestionLabel() {
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        questionLabel.textAlignment = .center
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.textColor = .titleColor
    }

    private func setupStackView() {
        answerStack.translatesAutoresizingMaskIntoConstraints = false
        answerStack.axis = .vertical
        answerStack.spacing = Constants.sidePadding
    }

    private func updateAnswerButton(button: UIButton, isCorrect: Bool) {
        button.backgroundColor = isCorrect == true ? .systemGreen : .systemRed
        button.setTitleColor(.textColor, for: .normal)
    }

    private func createCompletedView() {
        completedLabel.translatesAutoresizingMaskIntoConstraints = false
        completedLabel.textAlignment = .center
        completedLabel.font = UIFont.preferredFont(forTextStyle: .headline).withSize(30)
        completedLabel.text = "COMPLETED!"
        completedLabel.textColor = .titleColor
        completedLabel.alpha = 1.0
        view.addSubview(completedLabel)

        NSLayoutConstraint.activate([
            completedLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            completedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sidePadding),
            completedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sidePadding),
            completedLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func createDescriptionLabel(score: Int, category: String) {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .titleColor
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .headline).withSize(25)
        descriptionLabel.text = "You scored \(score) out of 10 in this \(category) quiz"
        view.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: completedCollectionView!.topAnchor, constant: -20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sidePadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sidePadding)
        ])
    }

    private func quizRoundEnded() {
        let timeInterval: TimeInterval
        timeInterval = score == 0 ? 0.1 : ResultHelper.createTimeInterval(score: score)

        var quizRoundResult = QuizRoundResult()
        quizRoundResult.resultString = ResultHelper.convertToPercentageString(score: score)
        quizRoundResult.category = category.title
        quizRoundResult.startTime = quizRoundStartDate
        quizRoundResult.endTime = quizQuestionResponses.last?.dateCompleted ?? Date()
        quizRoundResult.responses = quizQuestionResponses
        quizRoundResult.percentageCorrect = ResultHelper.convertToPercentage(score: score)
        quizRoundResult.difficulty = defaults.integer(forKey: "difficulty")
        quizRoundManager.saveResult(quizRoundResult)

        self.title = ""
        self.questionLabel.alpha = 0.0
        for button in self.answerButtonCollection {
            button.alpha = 0.0
        }
        self.createCompletedView()
        setupCollectionView()
        createDescriptionLabel(score: self.score, category: category.title)
        setUpCircularProgressBarView(toValue: ResultHelper.convertToDecimal(score: self.score))
        DispatchQueue.main.async {
            self.percentage = ResultHelper.convertToPercentage(score: self.score)
            self.currentCount = 0
            self.updateTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.updateLabel), userInfo: nil, repeats: true)
        }
    }

    // MARK: Objective C Functions
    @objc func quitButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @objc func updateLabel() {
        self.percentageLabel.text = "\(currentCount!)%"
        currentCount! += 1
        if currentCount! > percentage! {
            self.updateTimer?.invalidate()
            self.updateTimer = nil
            self.percentage = nil
            self.currentCount = nil
        }
    }

    @objc func answerButtonTapped(_ sender: UIButton) {

        guard let currentQuestion = currentQuestion else { return }
        for button in answerButtonCollection {
            button.isEnabled = false
        }

        let isCorrectAnswer = sender.title(for: .normal) == currentQuestion.correctAnswer
        let response = isCorrectAnswer ? Response.correct : Response.incorrect
        updateAnswerButton(button: sender, isCorrect: isCorrectAnswer)

        if isCorrectAnswer {
            score += 1
        }
        let quizQuestionResponse = QuizQuestionResponse(quizQuestion: currentQuestion, response: response, dateCompleted: Date())
        quizQuestionResponses.append(quizQuestionResponse)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.presentNextQuestion(animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension QuizViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - UICollectionViewDataSource
extension QuizViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        questions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CompletedQuestionsCell
        let quizQuestionResponse = quizQuestionResponses[indexPath.row]
        cell.label.text = quizQuestionResponse.quizQuestion.question
        cell.resultImage.image = quizQuestionResponse.response == .correct ? UIImage.correct : UIImage.incorrect
        return cell
    }
}

// MARK: - Constants
extension QuizViewController {
    enum Constants {
        static let sidePadding: CGFloat = 20
        static let topPadding: CGFloat = 100
        static let answerButtonHeight: CGFloat = 50

        static let cornerRadius: CGFloat = 5.0
        static let shadowRadius: CGFloat = 3.0
        static let shadowOffset: CGFloat = 2.0
        static let shadowOpacity: Float = 2.0
    }
}
