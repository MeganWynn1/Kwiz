//
//  CategoryViewController.swift
//  Kwiz
//
//  Created by Megan Wynn on 29/09/2021.
//

import UIKit

class CategoryViewController: UIViewController {

    var quizRoundManager: QuizRoundResultsManager!
    
    // MARK: - Properties
    private var collectionView: UICollectionView?
    private var identifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(quizRoundManager != nil)
        view.backgroundColor = .backgroundColor
        title = "Categories"
        setUpNavigationView()
        setupCollectionView()
    }

    // MARK: - Setup
    private func setUpNavigationView() {
        navigationController?.navigationBar.barTintColor = .backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.titleColor]
    }

    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.size.width-60, height: 70)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        guard let collectionView = collectionView else { return }
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = .backgroundColor

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func category(forIndexPath indexPath: IndexPath) -> QuizCategory? {
        let quizCategory = QuizCategory(rawValue: indexPath.row)
        return quizCategory
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let category = category(forIndexPath: indexPath) else {
            print("Unable to find category for index path: \(indexPath)")
            return
        }
        let viewController = QuizViewController()
        viewController.quizRoundManager = quizRoundManager
        viewController.category = category
        let quizNavigationController = UINavigationController(rootViewController: viewController)
        quizNavigationController.isModalInPresentation = true
        present(quizNavigationController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return QuizCategory.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryCell
        let values: [String] = QuizCategory.allCases.map { $0.title }
        cell.label.text = values[indexPath.item]
        return cell
    }
}


