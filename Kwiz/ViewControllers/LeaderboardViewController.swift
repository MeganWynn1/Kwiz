//
//  LeaderboardViewController.swift
//  Kwiz
//
//  Created by Megan Wynn on 26/10/2021.
//

import UIKit

class LeaderboardViewController: UIViewController {

    // MARK: - Properties
    var quizRoundManager: QuizRoundResultsManager!

    // MARK: - Private Properties
    private var identifier = "Cell"
    private var headerIdentifier = "Header"
    private var noResultsIdentifier = "NoResultsIdentifier"
    private let defaults: UserDefaults = .standard

    // MARK: - UIElements
    private var collectionView: UICollectionView!
    private var noResultsLabel = UILabel()
    private var segmentedControl = UISegmentedControl()
    private var buttonBar = UIView()

    private var datasource: UICollectionViewDiffableDataSource<SectionIdentifier, QuizRoundResult>!

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(quizRoundManager != nil)

        title = "Leaderboard"
        view.backgroundColor = .backgroundColor
        let quitButton = UIBarButtonItem(title: "Quit", style: .done, target: self, action: #selector(quitButtonTapped(_:)))
        quitButton.tintColor = .titleColor
        navigationItem.rightBarButtonItem = quitButton
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.titleColor]
        setupSegmentedControl()
        setupCollectionView()
        setupDatasource()

        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItems(difficulty: 0)
    }

    private func setupSegmentedControl() {
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor.primaryColor

        segmentedControl.insertSegment(withTitle: "Easy", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Medium", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Hard", at: 2, animated: false)
        segmentedControl.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 50)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .clear
        segmentedControl.backgroundColor = .white
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.secondaryColor], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.primaryColor], for: .selected)

        view.addSubview(segmentedControl)
        view.addSubview(buttonBar)

        NSLayoutConstraint.activate([
            buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            buttonBar.heightAnchor.constraint(equalToConstant: 5),
            buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor),
            buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments))
        ])
    }

    private func setupCollectionView() {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 30.0, bottom: 8.0, trailing: 30.0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(86))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]

        let layout = UICollectionViewCompositionalLayout(section: section)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LeaderboardCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.register(EmptyLeaderboardCell.self, forCellWithReuseIdentifier: noResultsIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .backgroundColor

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupDatasource() {
        datasource = UICollectionViewDiffableDataSource.init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            var resultCell: UICollectionViewCell

            if item.isNoResult {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.noResultsIdentifier, for: indexPath) as! EmptyLeaderboardCell
                resultCell = cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! LeaderboardCell
                cell.cellNumber = indexPath.row
                cell.result = item
                resultCell = cell
            }

            return resultCell
        })

        datasource?.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerIdentifier, for: indexPath) as? HeaderView else {
                fatalError("Could not dequeue sectionHeader: \(self.headerIdentifier)")
            }
            headerView.titleLabel.text = SectionIdentifier(rawValue: indexPath.section)?.headerTitle
            return headerView
        }
    }

    // Look at bitwise or bit-shifting!
    private func loadItems(animated: Bool = false, difficulty: Int) {
        quizRoundManager.getFilteredResults(difficulty: difficulty)
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, QuizRoundResult>()

        let todaysResults = quizRoundManager.todaysResults.count == 0 ? [QuizRoundResult.noResult()] : quizRoundManager.todaysResults
        let yesterdaysResults = quizRoundManager.yesterdaysResults.count == 0 ? [QuizRoundResult.noResult()] : quizRoundManager.yesterdaysResults
        let earlierResults = quizRoundManager.earlierResults.count == 0 ? [QuizRoundResult.noResult()] : quizRoundManager.earlierResults

        let leaderboardUtilities = LeaderboardUtilities()
        let style = leaderboardUtilities.leaderboardStyle(for: quizRoundManager.todaysResults, yesterdaysResults: quizRoundManager.yesterdaysResults, earlierResults: quizRoundManager.earlierResults)
        switch style {
        case .today0yesterday0earlier0, .today1yesterday0earlier0:
            snapshot.appendSections([.today])
            snapshot.appendItems(todaysResults, toSection: .today)
        case .today1yesterday1earlier0, .today0yesterday1earlier0:
            snapshot.appendSections([.today, .yesterday])
            snapshot.appendItems(todaysResults, toSection: .today)
            snapshot.appendItems(yesterdaysResults, toSection: .yesterday)
        case .today0yesterday0earlier1, .today1yesterday0earlier1, .today0yesterday1earlier1, .today1yesterday1earlier1:
            snapshot.appendSections([.today, .yesterday, .earlier])
            snapshot.appendItems(todaysResults, toSection: .today)
            snapshot.appendItems(yesterdaysResults, toSection: .yesterday)
            snapshot.appendItems(earlierResults, toSection: .earlier)
        }

        datasource.apply(snapshot, animatingDifferences: animated)
    }

    // MARK: Objective C Functions
    @objc func quitButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
      UIView.animate(withDuration: 0.3) {
          self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
          self.loadItems(difficulty: self.segmentedControl.selectedSegmentIndex)
      }
    }
}

// MARK: - Constants
extension LeaderboardViewController {
    enum Constants {
        static let sidePadding: CGFloat = 20
        static let topPadding: CGFloat = 100
    }
}
