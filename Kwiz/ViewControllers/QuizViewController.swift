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
    private var percentage: Int?
    private var currentCount: Int?
    private var updateTimer: Timer?
    private var identifier = "QuestionsCell"
    private var progressIdentifier = "ProgressCell"
    private var completedIdentifier = "CompletedLabelCell"
    private var quizQuestionResponses: [QuizQuestionResponse] = []
    private var quizRoundStartDate: Date!
    private var cancellable: AnyCancellable?
    private var datasource: UICollectionViewDiffableDataSource<Section, QuizQuestionResponse>!
    private let numberOfQuestions = 1

    // MARK: - UI Elements
    private var questionLabel = UILabel()
    private var percentageLabel = UILabel()
    private var answerStack = UIStackView()
    private var answerButtonCollection = [AnswerButton]()
    private var completedLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var spinner: UIActivityIndicatorView!
    private var completedCollectionView: UICollectionView!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(quizRoundManager != nil)
        configure()
        completedLabel.alpha = 0.0
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
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.completedIdentifier, for: indexPath) as! CompletedLabelCell
                cell.label.text = "Completed"
                cell.label.font = UIFont.preferredFont(forTextStyle: .body).withSize(22)
                return cell
            } else if indexPath.row == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.progressIdentifier, for: indexPath) as! CircularProgressCell
                return cell
            } else if indexPath.row == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.completedIdentifier, for: indexPath) as! CompletedLabelCell
                cell.label.text = "You scored \(score) out of 10 in this \(category) quiz"
                cell.label.font = UIFont.preferredFont(forTextStyle: .body).withSize(16)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! CompletedQuestionsCell
                cell.label.text = item.quizQuestion.question
                cell.resultImage.image = item.response == .correct ? UIImage.correct : UIImage.incorrect
                return cell
            }
        })
    }

    private func loadItems(animated: Bool = false) {
        var quizQuestionResponses = [QuizQuestionResponse.fakeResponse(), QuizQuestionResponse.fakeResponse(), QuizQuestionResponse.fakeResponse()]
        quizQuestionResponses.append(contentsOf: self.quizQuestionResponses)
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
                case .failure(_):
                    print("error")
                }
            }
        }
    }

    private func filteredQuestions(from questions: [QuizQuestion], shuffled: Bool = true, numberOfQuestions: Int) -> [QuizQuestion]? {

        guard questions.count >= numberOfQuestions else { return nil }
        var quizQuestions: [QuizQuestion] = []
        var allAnswers: [String] = []

        var candidateQuestions = questions
        if shuffled { candidateQuestions.shuffle() }

        cancellable = candidateQuestions.publisher
            .removeDuplicates { prev, current in
                prev.id == current.id
            }
            .sink {
                allAnswers.append($0.correctAnswer)
                allAnswers.append(contentsOf: $0.incorrectAnswers)
                if allAnswers.allSatisfy({ $0.count <= 60 }) {
                    quizQuestions.append($0)
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
        print(currentQuestion!.correctAnswer)
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

    private func setupCollectionView() {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 30.0, bottom: 8.0, trailing: 30.0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(86.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)

        completedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        completedCollectionView.register(CompletedQuestionsCell.self, forCellWithReuseIdentifier: identifier)
        completedCollectionView.register(CircularProgressCell.self, forCellWithReuseIdentifier: progressIdentifier)
        completedCollectionView.register(CompletedLabelCell.self, forCellWithReuseIdentifier: completedIdentifier)
        completedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        completedCollectionView.backgroundColor = .backgroundColor

        view.addSubview(completedCollectionView)

        NSLayoutConstraint.activate([
            completedCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            completedCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            completedCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            completedCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        quizRoundResult.percentageCorrect = ResultHelper.convertToPercentage(score: score)
        quizRoundResult.difficulty = defaults.integer(forKey: "difficulty")
        quizRoundManager.saveResult(quizRoundResult)

        self.title = ""
        self.questionLabel.alpha = 0.0
        for button in self.answerButtonCollection {
            button.alpha = 0.0
        }

        setupCollectionView()
        setupDatasource(score: score, category: category.title)
        loadItems()
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

// MARK: - Constants
extension QuizViewController {
    enum Constants {
        static let sidePadding: CGFloat = 20
        static let topPadding: CGFloat = 20
        static let bottomPadding: CGFloat = 40
        static let answerButtonHeight: CGFloat = 60

        static let cornerRadius: CGFloat = 5.0
        static let shadowRadius: CGFloat = 3.0
        static let shadowOffset: CGFloat = 2.0
        static let shadowOpacity: Float = 2.0
    }
}
