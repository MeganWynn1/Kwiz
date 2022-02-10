//
//  LeaderboardViewController.swift
//  Quiz
//
//  Created by Megan Wynn on 26/10/2021.
//

import UIKit

class LeaderboardViewController: UIViewController {

    // MARK: - Properties
    var quizRoundPersistanceService: QuizRoundPersistanceService!

    // MARK: - Private Properties
    private var identifier = "Cell"
    private var headerIdentifier = "Header"

    // MARK: - UIElements
    private var collectionView: UICollectionView!
    private var noResultsLabel = UILabel()

    private var datasource: UICollectionViewDiffableDataSource<SectionIdentifier, QuizRoundResult>!

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(quizRoundPersistanceService != nil)

        title = "Leaderboard"
        view.backgroundColor = .backgroundColour
        let quitButton = UIBarButtonItem(title: "Quit", style: .done, target: self, action: #selector(quitButtonTapped(_:)))
        quitButton.tintColor = .label
        navigationItem.rightBarButtonItem = quitButton
        setupCollectionView()
        setupDatasource()

        if quizRoundPersistanceService.getAllQuizRoundResults().count == 0 {
            setupNoResultsLabel()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItems()
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
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .backgroundColour

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupDatasource() {
        datasource = UICollectionViewDiffableDataSource.init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! LeaderboardCell
            cell.cellNumber = indexPath.row
            cell.result = item

            return cell
        })

        datasource?.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerIdentifier, for: indexPath) as? HeaderView else {
                fatalError("Could not dequeue sectionHeader: \(self.headerIdentifier)")
            }
            headerView.titleLabel.text = SectionIdentifier(rawValue: indexPath.section)?.headerTitle
            return headerView
        }
    }

    private func loadItems(animated: Bool = false) {
        let allResults = quizRoundPersistanceService.getAllQuizRoundResults()
        guard let yesterdaysDate = Calendar.current.date(byAdding: .day, value: -1, to: Date().stripTime()) else {
            print("Unable to calculate yesterday's date")
            return
        }

        let todaysResults = allResults.filter({ $0.date == Date().stripTime() }).sorted { $0 == $1 ? $0.seconds < $1.seconds : $0 > $1  }
        let yesterdaysResults = allResults.filter({ $0.date == yesterdaysDate }).sorted { $0 == $1 ? $0.seconds < $1.seconds : $0 > $1  }
        let earlierResults = allResults.filter({ $0.date < yesterdaysDate }).sorted { $0 == $1 ? $0.seconds < $1.seconds : $0 > $1  }

        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, QuizRoundResult>()
        snapshot.appendSections([.today, .yesterday, .earlier])
        snapshot.appendItems(todaysResults, toSection: .today)
        snapshot.appendItems(yesterdaysResults, toSection: .yesterday)
        snapshot.appendItems(earlierResults, toSection: .earlier)
        datasource.apply(snapshot, animatingDifferences: animated)
    }

    private func setupNoResultsLabel() {
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        noResultsLabel.text = "Currently no results recorded"
        noResultsLabel.textAlignment = .center
        noResultsLabel.font = UIFont.preferredFont(forTextStyle: .caption1).withSize(22)
        view.addSubview(noResultsLabel)

        NSLayoutConstraint.activate([
            noResultsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.topPadding),
            noResultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sidePadding),
            noResultsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sidePadding),
            noResultsLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: Objective C Functions
    @objc func quitButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Constants
extension LeaderboardViewController {
    enum Constants {
        static let sidePadding: CGFloat = 20
        static let topPadding: CGFloat = 100
    }
}
