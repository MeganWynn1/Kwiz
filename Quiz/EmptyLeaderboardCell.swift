//
//  EmptyLeaderboardCell.swift
//  Quiz
//
//  Created by Megan Wynn on 23/03/2022.
//

import UIKit

class EmptyLeaderboardCell: BaseCell {

    // MARK: - UI Elements
    private var noResultsLabel = UILabel()

    // MARK: - Initialise
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupLabel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupLabel() {
        noResultsLabel.textColor = .secondaryColor
        noResultsLabel.text = "No Results"
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(noResultsLabel)

        NSLayoutConstraint.activate([
            noResultsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.labelPadding),
            noResultsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.labelPadding),
            noResultsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelPadding),
            noResultsLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}

// MARK: - Constants
extension EmptyLeaderboardCell {
    enum Constants {
        static let labelPadding: CGFloat = 10
    }
}
