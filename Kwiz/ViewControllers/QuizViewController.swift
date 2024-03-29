//
//  QuizViewController.swift
//  Kwiz
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
    private var identifier = "QuestionsCell"
    private var quizQuestionResponses: [QuizQuestionResponse] = []
    private var quizRoundStartDate: Date!
    private var cancellable: AnyCancellable?
    private var datasource: UICollectionViewDiffableDataSource<Section, QuizQuestionResponse>!
    private let numberOfQuestions = 10

    // MARK: - UI Elements
    private var questionLabel = UILabel()
    private var answerStack = UIStackView()
    private var answerButtonCollection = [AnswerButton]()
    private var spinner: UIActivityIndicatorView!
    private var completedCollectionView: UICollectionView!
    private var congratsLabel = UILabel()
    private var percentageLabel = UILabel()
    private var circularProgressView = CircularProgressView()

    // MARK: - Timer elements
    private var maxCount: Int = 0
    private var currentCount: Int = 0
    private var updateTimer: Timer?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(quizRoundManager != nil)
        configure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getQuestions()
        addViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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

    private func setupDatasource(score: Int, category: String) {
        datasource = UICollectionViewDiffableDataSource.init(collectionView: completedCollectionView, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! CompletedQuestionsCell
            cell.label.text = item.quizQuestion.question
            cell.resultImage.image = item.response == .correct ? UIImage.correct : UIImage.incorrect
            return cell
        })
    }

    private func loadItems(animated: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, QuizQuestionResponse>()
        snapshot.appendSections([.main])
        snapshot.appendItems(quizQuestionResponses, toSection: .main)
        datasource.apply(snapshot, animatingDifferences: animated)
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
                    self.questions = self.filteredQuestions(from: questions, numberOfQuestions: self.numberOfQuestions) ?? []
                    self.presentNextQuestion(animated: false)
                case .failure(let error):
                    self.handleGetQuestionsError(error: error)
                }
            }
        }
    }
    
    private func handleGetQuestionsError(error: QuizQuestionServiceError) {
        var alertController: UIAlertController
        switch error {
        case .noInternetConnection:
            alertController = UIAlertController(title: "No Internet Connection", message: "Please check your internet connect and try again", preferredStyle: .alert)
        case .missingData, .invalidResponseError, .unknown:
            alertController = UIAlertController(title: "There has been a problem", message: "There has been a problem with our questions server, please try again later", preferredStyle: .alert)
            break
        }
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func filteredQuestions(from questions: [QuizQuestion], shuffled: Bool = true, numberOfQuestions: Int) -> [QuizQuestion]? {
        guard questions.count >= numberOfQuestions else { return nil }
        var quizQuestions: [QuizQuestion] = []

        if shuffled { self.questions.shuffle() }

        let filteredQuestions = Array(Set(questions))
        for a in filteredQuestions {
            if a.correctAnswer.count <= 70 || a.incorrectAnswers.allSatisfy({ $0.count <= 60 }) {
                quizQuestions.append(a)
            }
        }

        let result = Array(quizQuestions.prefix(numberOfQuestions))
        guard result.count >= numberOfQuestions else { return nil }

        return result
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
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.titleLabel?.textAlignment = .center
            button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
            button.isEnabled = true

            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09)
            ])
        }
    }

    private func setupQuestionLabel() {
        let fontSize = view.frame.height/30
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.systemFont(ofSize: fontSize)
        questionLabel.textAlignment = .center
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.textColor = .titleColor
    }

    private func setupStackView() {
        answerStack.translatesAutoresizingMaskIntoConstraints = false
        answerStack.axis = .vertical
        answerStack.spacing = 10
    }

    private func updateAnswerButton(button: UIButton, isCorrect: Bool) {
        button.backgroundColor = isCorrect == true ? .systemGreen : .systemRed
        button.setTitleColor(.textColor, for: .normal)
    }

    private func addViews() {
        setupQuestionLabel()
        setupStackView()
        view.addSubview(questionLabel)
        view.addSubview(answerStack)

        NSLayoutConstraint.activate([
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topPadding),
            questionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: Constants.sidePadding),
            questionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -Constants.sidePadding),

            answerStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.bottomPadding),
            answerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sidePadding),
            answerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sidePadding)
        ])
    }

    @objc func updateLabel() {
        percentageLabel.text = "\(currentCount)%"
            currentCount += 1
            if currentCount > maxCount {
                self.updateTimer?.invalidate()
                self.updateTimer = nil
            }
        }

    private func setUpProgressView(percentage: Float) {
        circularProgressView.createCircularPath()
        circularProgressView.progressAnimation(toValue: percentage)
        circularProgressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circularProgressView)

        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.textAlignment = .center
        percentageLabel.textColor = .titleColor
        percentageLabel.font = UIFont.preferredFont(forTextStyle: .body).withSize(28)
        percentageLabel.text = "\(currentCount)%"
        view.addSubview(percentageLabel)

        DispatchQueue.main.async {
            guard self.score*10 != 0 else { return }
            let time = Double(2)/Double(self.score*10)
            self.maxCount = self.score*10
            self.updateTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(self.updateLabel), userInfo: nil, repeats: true)
        }

        congratsLabel.numberOfLines = 0
        congratsLabel.translatesAutoresizingMaskIntoConstraints = false
        congratsLabel.textAlignment = .center
        congratsLabel.textColor = .titleColor
        congratsLabel.text = "Congratulations! \nYou scored \(score) out of \(self.numberOfQuestions) in this \(category.title.lowercased()) quiz"
        view.addSubview(congratsLabel)

        NSLayoutConstraint.activate([
            circularProgressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.circleRadius + Constants.topPadding),
            circularProgressView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            percentageLabel.topAnchor.constraint(equalTo: circularProgressView.topAnchor, constant: -Constants.halfLabelHeight),
            percentageLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            congratsLabel.topAnchor.constraint(equalTo: circularProgressView.bottomAnchor, constant: Constants.circleRadius + Constants.topPadding),
            congratsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.halfLabelHeight),
            congratsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.halfLabelHeight)
        ])
    }

    private func setupCollectionView() {
        let heightDimension = NSCollectionLayoutDimension.estimated(180)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 30.0, bottom: 20, trailing: 30.0)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15

        let layout = UICollectionViewCompositionalLayout(section: section)

        completedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        completedCollectionView.register(CompletedQuestionsCell.self, forCellWithReuseIdentifier: identifier)
        completedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        completedCollectionView.backgroundColor = .backgroundColor

        view.addSubview(completedCollectionView)

        NSLayoutConstraint.activate([
            completedCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            completedCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            completedCollectionView.topAnchor.constraint(equalTo: congratsLabel.bottomAnchor, constant: Constants.topPadding),
            completedCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func quizRoundEnded() {
        var quizRoundResult = QuizRoundResult()
        quizRoundResult.resultString = ResultHelper.convertToPercentageString(score: score)
        quizRoundResult.category = category.title
        quizRoundResult.startTime = quizRoundStartDate
        quizRoundResult.endTime = quizQuestionResponses.last?.dateCompleted ?? Date()
        quizRoundResult.percentageCorrect = ResultHelper.convertToPercentage(score: score)
        quizRoundResult.difficulty = defaults.integer(forKey: "difficulty")
        quizRoundManager.saveResult(quizRoundResult)

        self.title = "Completed!"
        self.questionLabel.alpha = 0.0
        for button in self.answerButtonCollection {
            button.alpha = 0.0
        }

        setUpProgressView(percentage: Float(score)/10)
        setupCollectionView()
        setupDatasource(score: score, category: category.title)
        loadItems()
    }

    // MARK: Objective C Functions
    @objc func quitButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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

// MARK: - Constants
extension QuizViewController {
    enum Constants {
        static let sidePadding: CGFloat = 20
        static let topPadding: CGFloat = 20
        static let bottomPadding: CGFloat = 40
        static let answerButtonHeight: CGFloat = 60
        static let circleRadius: CGFloat = 90
        static let halfLabelHeight: CGFloat = 15
    }
}
