//
//  CategoryCell.swift
//  Kwiz
//
//  Created by Megan Wynn on 29/09/2021.
//

import UIKit

class CategoryCell: BaseCell {

    // MARK: - Properties
    var label = UILabel()

    // MARK: - Initialise
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.font
        label.textAlignment = .center
        label.textColor = .textColor
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.labelPadding),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.labelPadding),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelPadding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.labelPadding)
        ])
    }

}

// MARK: - Constants
extension CategoryCell {
    enum Constants {
        static let labelPadding: CGFloat = 10
        static let font = UIFont.preferredFont(forTextStyle: .body).withSize(22)
    }
}

