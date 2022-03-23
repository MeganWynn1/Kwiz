//
//  EmptyLeaderboardCell.swift
//  Kwiz
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
        contentView.layer.borderColor = UIColor.secondaryColor.cgColor
        contentView.layer.borderWidth = 2
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
            noResultsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: - Constants
extension EmptyLeaderboardCell {
    enum Constants {
        static let labelPadding: CGFloat = 10
    }
}
